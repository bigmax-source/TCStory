/*
 * Supabase 前台連線設定。
 * Publishable key 可以公開於前端；絕對不可填入 sb_secret 開頭的 Secret key。
 */
window.SUPABASE_URL = 'https://nkusmsvnsixpsgrlpnwp.supabase.co';
window.SUPABASE_PUBLISHABLE_KEY = 'sb_publishable_KDjaAlRvHqcrdvOI8uZX5w_g1McbMmC';

window.supabaseClient = window.supabase
  ? window.supabase.createClient(window.SUPABASE_URL, window.SUPABASE_PUBLISHABLE_KEY)
  : null;
