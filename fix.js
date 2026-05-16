const fs = require('fs');
let c = fs.readFileSync('lib/main.dart', 'utf8');
c = c.replace(/\.withValues\(alpha:\s*\)/g, '.withAlpha(128)');
fs.writeFileSync('lib/main.dart', c);
