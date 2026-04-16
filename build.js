// Vercel 빌드 스크립트
// 환경변수를 index.html 플레이스홀더에 주입해서 dist/index.html 을 생성합니다.

const fs   = require('fs');
const path = require('path');

const url = process.env.SUPABASE_URL;
const key = process.env.SUPABASE_KEY;

if (!url || !key) {
  console.error('[build] ERROR: SUPABASE_URL 또는 SUPABASE_KEY 환경변수가 없습니다.');
  console.error('Vercel 대시보드 > Settings > Environment Variables 에서 설정해주세요.');
  process.exit(1);
}

const src  = path.join(__dirname, 'index.html');
const out  = path.join(__dirname, 'dist', 'index.html');

fs.mkdirSync(path.dirname(out), { recursive: true });

let html = fs.readFileSync(src, 'utf8');
html = html.replace(/%%SUPABASE_URL%%/g, url);
html = html.replace(/%%SUPABASE_KEY%%/g, key);

fs.writeFileSync(out, html, 'utf8');
console.log('[build] dist/index.html 생성 완료');
