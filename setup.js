#!/bin/env node

const mariadb = require('mariadb');
const fs = require('fs');
const path = require('path');

if (process.argv.length != 5) {
    console.log(`Usage: ${process.argv[0]} <host> <login name> <database name>`);
    return;
}

async function runSQL(sqlPath) {
    try {
        const absolutePath = path.join(__dirname, sqlPath);
        console.log(`Executing SQL file: ${absolutePath}`)
        const sql = await fs.promises.readFile(absolutePath, 'utf-8');
        await conn.query(sql);
    } catch (error) {
        console.error(`Failed to execute SQL: ${error.message}`)
    }
}

const host = process.argv[2];
const user = process.argv[3];
const database = process.argv[4];

const connectionOptions = {
    host: host,
    user: user,
    password: process.env.POEM_DBSETUP_PASSWORD,
    multipleStatements: true
}

let conn;

async function run() {
    try {
        console.log(`Connecting to ${user}@${host}.`)
        console.log(`Using database ${database}.`)

        conn = await mariadb.createConnection(connectionOptions)
        await conn.query(`DROP DATABASE IF EXISTS \`${database}\``);
        await conn.query(`CREATE DATABASE \`${database}\``);
        await conn.query(`USE \`${database}\``);
        await exec();
        await conn.close();
    } catch (error) {
        console.error('Error:');
        const index = error.message.indexOf('sql:');
        if (index != -1)
            console.error(error.message.substring(0, index));
        else
            console.log(error.message);
    }
}

async function exec() {
    await runSQL('sql/user/defaultlogin.sql');
    await runSQL('sql/user/googlelogin.sql');
    await runSQL('sql/user/wallet-restriction.sql');
    await runSQL('sql/user/user.sql');
}

run();
