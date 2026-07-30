-- 在 Supabase Dashboard 的 SQL Editor 貼上並執行此檔案。
-- 完成後請在 Authentication > Users 建立管理者帳號，並在
-- Authentication > Providers 關閉 Email 的「Allow new users to sign up」。

create table if not exists public.stories (
  id bigint generated always as identity primary key,
  category text not null check (category in ('地理與交通','生活與日常','人文與地方','歷史與記憶')),
  title text not null check (char_length(title) between 1 and 100),
  content text not null,
  list_items text[] not null default '{}',
  sort_order integer not null default 1,
  is_published boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.stories enable row level security;
create policy "公開讀取已發布故事" on public.stories for select using (is_published = true);
create policy "登入者可管理故事" on public.stories for all to authenticated using (true) with check (true);

-- 自動更新修改時間
create or replace function public.set_updated_at() returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end; $$;
drop trigger if exists stories_updated_at on public.stories;
create trigger stories_updated_at before update on public.stories for each row execute function public.set_updated_at();

-- 將目前 16 則內容匯入後台（新的專案請執行一次）。
insert into public.stories (category,title,content,list_items,sort_order) values
('地理與交通','七個臺鐵車站，串起頭城的海岸線','頭城從北到南有七個臺鐵車站：石城、大里、大溪、龜山、外澳、頭城、頂埔，是全台灣擁有最多車站的鄉鎮。','{}',1),
('生活與日常','青雲路上的二十家檳榔攤','頭城青雲路從頭城國小到頭城陸橋之間，有二十家檳榔攤。','{}',2),
('地理與交通','八個漁港，面向同一片太平洋','頭城從北到南有八個漁港，是全台灣擁有最多漁港的鄉鎮。',array['石城','桶盤堀','大里','蕃薯寮','大溪第二漁港','大溪第一漁港','梗枋','烏石漁港'],3),
('歷史與記憶','蘭陽博物館以前，是一片果園','蘭陽博物館於 2004 年 8 月開工、2010 年 5 月試營運；這座地景建築的前身，是一大片芭樂園與柚子樹。','{}',4),
('歷史與記憶','香雞城曾經在這裡','1995 年前後頭城曾開過《香雞城》，地點在現在青雲路《老街懷舊食堂》的店面。','{}',5),
('人文與地方','頭城的青年，人才輩出','「頭城文風鼎盛，人才輩出」？不 Google 的話，能說出幾位頭城相關、40 歲以下的優秀青年呢？',array['楊肅浩（唱片歌手、宜中教師）','賴志遠（出書作家、宜中教師）','連明偉（台灣當代作家）','康潤之（書法家）','李慈雲（全運會鐵餅金牌、宜中教練）','陳建嘉（富邦籃球隊、宜中教練、頭中教練）','張宗憲（富邦勇士隊、台灣噴射機）'],6),
('生活與日常','凌晨三點，還有頭城豆漿店','除了便利商店，半夜三點肚子餓的話，只有《85度C》對面的《頭城豆漿店》有開。','{}',7),
('生活與日常','車站 300 公尺內，超過 30 家早餐店','以頭城車站為圓心，包含便利商店，半徑 300 公尺內有超過 30 家賣早餐的店家。','{}',8),
('人文與地方','頭城出過三位民選縣長','頭城出過三位民選縣長：',array['盧纘祥（1951–1954）','林才添（1960–1964）','呂國華（2005–2009）'],9),
('地理與交通','青雲路口，請慢一點','頭城青雲路從頭城國小到阿宗芋冰，是砂石車、大卡車最容易闖紅燈的路口，用路人請小心。','{}',10),
('人文與地方','2026 年的頭城：27,969 人','根據戶政資料，從 2014 年開始，頭城鎮人口即跌破三萬人；2026 年 6 月為 27,969 人，鎮公所已沒有「主祕」一缺。','{}',11),
('歷史與記憶','十元玩十五分鐘的小豆苗','頭城曾經有過《小豆苗》，現址已貼出租。老闆同地還開過電動玩具店，任天堂紅白機新台幣 10 元玩 15 分鐘的那種。','{}',12),
('生活與日常','星期五夜市的駕駛技術','逛星期五頭城夜市時，有機會可以欣賞遊覽車司機高超的駕駛技術。','{}',13),
('歷史與記憶','2002 年的鐵板燒店','2002 年，頭城鎮上曾經有過「鐵板燒店」，就在現在頭城商場燒餅蛋餅店店面。','{}',14),
('歷史與記憶','九股山上的垃圾記憶','宜蘭還沒有焚化爐前，頭城的垃圾都是掩埋在九股山上（1980–2004）。','{}',15),
('歷史與記憶','青雲路旁的 MTV 店','頭城曾經有過 MTV 店，就在青雲路《合記便當》旁、檳榔攤那棟大樓。','{}',16);
