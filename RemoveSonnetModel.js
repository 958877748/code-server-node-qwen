#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

// 要处理的文件路径（相对路径，因为执行时已经在claudecodeui目录中）
const targetFile = 'server/claude-cli.js';

// 要删除的代码行
const codeToRemove = "args.push('--model', 'sonnet');";

console.log('开始删除Sonnet模型代码...');

try {
    // 检查文件是否存在
    if (!fs.existsSync(targetFile)) {
        console.log(`文件 ${targetFile} 不存在，跳过删除操作`);
        process.exit(0);
    }

    // 读取文件内容
    const content = fs.readFileSync(targetFile, 'utf8');
    
    // 检查是否包含要删除的代码
    if (!content.includes(codeToRemove)) {
        console.log(`文件 ${targetFile} 中未找到要删除的代码: ${codeToRemove}`);
        process.exit(0);
    }

    // 删除指定代码行
    const lines = content.split('\n');
    const newLines = lines.filter(line => !line.includes(codeToRemove));
    
    // 写入修改后的内容
    fs.writeFileSync(targetFile, newLines.join('\n'));
    
    console.log(`成功从 ${targetFile} 中删除代码: ${codeToRemove}`);
    console.log('Sonnet模型代码删除完成！');

} catch (error) {
    console.error('处理文件时发生错误:', error.message);
    process.exit(1);
}
