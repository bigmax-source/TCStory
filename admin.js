(() => {
  const client = window.supabaseClient;
  const $ = id => document.getElementById(id);
  let stories = [], selectedId = null;
  const say = (id, message='', type='') => { const el=$(id); el.textContent=message; el.className=`status ${type}`; };
  if (!client) { $('setup').classList.remove('hidden'); $('login').classList.add('hidden'); return; }

  const resetForm = () => { selectedId=null; $('storyForm').reset(); $('sortOrder').value=(Math.max(0,...stories.map(s=>s.sort_order||0))+1); $('published').checked=true; $('formTitle').textContent='新增故事'; $('deleteButton').classList.add('hidden'); say('formStatus'); document.querySelectorAll('.item').forEach(x=>x.classList.remove('selected')); };
  const select = id => { const s=stories.find(x=>x.id===id); if(!s)return; selectedId=id; $('storyId').value=s.id; $('category').value=s.category; $('sortOrder').value=s.sort_order; $('title').value=s.title; $('content').value=s.content; $('listItems').value=(s.list_items||[]).join('\n'); $('published').checked=s.is_published; $('formTitle').textContent='編輯故事'; $('deleteButton').classList.remove('hidden'); document.querySelectorAll('.item').forEach(x=>x.classList.toggle('selected',x.dataset.id===String(id))); say('formStatus'); };
  const draw = () => { $('storyList').innerHTML=stories.length?stories.map(s=>`<li class="item ${s.id===selectedId?'selected':''}" data-id="${s.id}"><b>${s.sort_order}. ${s.title}</b><small>${s.category} · ${s.is_published?'已發布':'草稿'}</small></li>`).join(''):'<li class="item">尚無故事</li>'; };
  async function fetchStories(){ const {data,error}=await client.from('stories').select('*').order('sort_order'); if(error){say('formStatus',error.message,'error');return;} stories=data||[]; draw(); }
  async function showApp(session){ $('login').classList.add('hidden'); $('app').classList.remove('hidden'); $('userEmail').textContent=session.user.email; await fetchStories(); resetForm(); }
  $('loginButton').onclick=async()=>{ say('loginStatus','登入中…'); const {data,error}=await client.auth.signInWithPassword({email:$('email').value,password:$('password').value}); if(error)return say('loginStatus',error.message,'error'); showApp(data.session); };
  $('logoutButton').onclick=async()=>{await client.auth.signOut();$('app').classList.add('hidden');$('login').classList.remove('hidden');say('loginStatus');};
  $('newButton').onclick=resetForm; $('storyList').onclick=e=>{const item=e.target.closest('.item[data-id]');if(item)select(Number(item.dataset.id));};
  $('storyForm').onsubmit=async e=>{e.preventDefault();const payload={category:$('category').value,sort_order:Number($('sortOrder').value),title:$('title').value.trim(),content:$('content').value.trim(),list_items:$('listItems').value.split('\n').map(x=>x.trim()).filter(Boolean),is_published:$('published').checked};say('formStatus','儲存中…');const request=selectedId?client.from('stories').update(payload).eq('id',selectedId):client.from('stories').insert(payload).select().single();const {data,error}=await request;if(error)return say('formStatus',error.message,'error');say('formStatus','已儲存。','ok');if(data)selectedId=data.id;await fetchStories();if(selectedId)select(selectedId);};
  $('deleteButton').onclick=async()=>{if(!selectedId||!confirm('確定要刪除這則故事嗎？'))return;const {error}=await client.from('stories').delete().eq('id',selectedId);if(error)return say('formStatus',error.message,'error');resetForm();await fetchStories();};
  client.auth.getSession().then(({data:{session}})=>{if(session)showApp(session);});
})();
