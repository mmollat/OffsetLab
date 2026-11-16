// Real React state/effect interactions with a deterministic, read-only fixture API.
// No live credentials, network, or database writes. Run: node scripts/test-factory-generation.cjs
const assert = require('node:assert/strict');
const fs = require('node:fs');
const ts = require('typescript');
const Module = require('node:module');
const React = require('react');
const {create, act} = require('react-test-renderer');
for (const ext of ['.ts','.tsx']) require.extensions[ext] = (module, filename) => module._compile(ts.transpileModule(fs.readFileSync(filename,'utf8'), {compilerOptions:{module:ts.ModuleKind.CommonJS,jsx:ts.JsxEmit.ReactJSX,esModuleInterop:true}}).outputText,filename);
const {readFactoryGeneration, model3FactoryBaseline, model3ConfigurationHint} = require('../app/lib/model3Factory.ts');
assert.equal(readFactoryGeneration(null),'2024-plus');
assert.equal(readFactoryGeneration('invalid'),'2024-plus');
const preset={title:'Aggressive',subtitle:'',front:'20x9 +25',rear:'20x10.5 +36',frontTire:'245/35R20',rearTire:'285/30R20',pokeFront:'Aggressive street front fitment',pokeRear:'Strong staggered rear stance',innerFront:'Moderate',innerRear:'Moderate-to-tight',diameter:'20 inch staggered',aggression:9,daily:5,risk:'High',verdict:'Test aftermarket setup',alternate:'',warnings:[],variants:[]};
const base={front:'20x9 +34',rear:'20x10 +45',tire:'235/35R20',frontTire:'235/35R20',rearTire:'275/30R20',boltPattern:'5x114.3',centerBore:'64.1mm'};
const db={'Model 3':[{trim:'Performance',baseline:base,presets:{oemplus:preset,flush:preset,aggressive:preset}}],M4:[{trim:'Base',baseline:{...base,rear:'20x9 +34',rearTire:'235/35R20'},presets:{oemplus:preset,flush:preset,aggressive:preset}}]};
const models=[{make:'Tesla',model:'Model 3',active:true},{make:'BMW',model:'M4',active:true}];
const trims=[{make:'Tesla',model:'Model 3',trim:'Performance',active:true},{make:'BMW',model:'M4',trim:'Base',active:true}];
const originalLoad=Module._load;
Module._load=function(request,parent,isMain){
 if(request.endsWith('/getFitmentData')) return {getFitmentData:async()=>db};
 if(request.endsWith('/getVehicleModels')) return {getVehicleModels:async()=>models};
 if(request.endsWith('/getVehicleTrims')) return {getVehicleTrims:async()=>trims};
 if(request==='next/link') return ({children,...props})=>React.createElement('a',props,children);
 if(request.endsWith('/supabase')) return {supabase:{from:()=>{const q={select:()=>q,eq:()=>q,order:()=>q,then:r=>Promise.resolve({data:[],error:null}).then(r)};return q;}}};
 if(parent?.filename.endsWith('/fitment/page.tsx')&&request.includes('/components/')&&!request.endsWith('/FactoryGenerationSelect')) return ()=>null;
 return originalLoad.call(this,request,parent,isMain);
};
const Compare=require('../app/compare/page.tsx').default;
const Fitment=require('../app/fitment/page.tsx').default;
function browser(url){
 const listeners=new Map(); let stack=[new URL(url,'https://offset-lab.com')], index=0;
 const w={get location(){return stack[index]},addEventListener:(name,fn)=>{const set=listeners.get(name)||new Set();set.add(fn);listeners.set(name,set)},removeEventListener:(name,fn)=>listeners.get(name)?.delete(fn),dispatchEvent:event=>{for(const fn of listeners.get(event.type)||[])fn(event)},history:{
 replaceState:(_state,_title,url)=>{stack[index]=new URL(url,stack[index])},
 pushState:(_state,_title,url)=>{stack=stack.slice(0,index+1);stack.push(new URL(url,stack[index]));index++},
 back:()=>{if(index>0){index--;w.dispatchEvent({type:'popstate'})}},forward:()=>{if(index<stack.length-1){index++;w.dispatchEvent({type:'popstate'})}}
 }};global.window=w;return w;
}
const text=node=>node==null?'':typeof node==='string'?node:Array.isArray(node)?node.map(text).join(' '):text(node.children);
const selector=tree=>tree.root.findAllByType('select').find(s=>s.findAllByType('option').some(o=>o.props.value==='2017-2023'));
const choose=async(tree,value)=>act(async()=>selector(tree).props.onChange({target:{value}}));
const rear=async(tree)=>{const button=tree.root.findAllByType('button').find(b=>text(b.toJSON?.()??{children:b.children})==='rear');await act(async()=>button.props.onClick());};
(async()=>{
 for(const query of ['', '&factoryGeneration=2024-plus','&factoryGeneration=nonsense','&factoryGeneration=2017-2023']){
  browser('/compare?make=Tesla&model=Model+3&trim=Performance&style=aggressive'+query);
  let tree;await act(async()=>{tree=create(React.createElement(Compare))});
  const older=query.endsWith('2017-2023');assert.equal(selector(tree).props.value,older?'2017-2023':'2024-plus');
  await rear(tree);let html=text(tree.toJSON());assert.ok(html.includes(older?'20x9 +34 / 235':'20x10 +45 / 275'));
  assert.ok(html.includes('20x10.5 +36 / 285'));assert.ok(html.includes('245/35R20'));
  await act(async()=>tree.unmount());
 }
 // Preserve the exact selected aftermarket handoff and current style in share links.
 browser('/compare?make=Tesla&model=Model+3&trim=Performance&style=aggressive&front=20x9+%2B25&rear=20x10.5+%2B36&frontTire=245%2F35R20&rearTire=285%2F30R20&title=Custom&verdict=Same+setup');
 let tree;await act(async()=>{tree=create(React.createElement(Compare))});await rear(tree);
 await choose(tree,'2017-2023');assert.equal(window.location.searchParams.get('frontTire'),'245/35R20');assert.equal(window.location.searchParams.get('rear'),'20x10.5 +36');assert.equal(window.location.searchParams.get('title'),'Custom');
 assert.ok(text(tree.toJSON()).includes('20x9 +34 / 235'));assert.ok(text(tree.toJSON()).includes('+17mm outward'));
 const oldWidth=tree.root.findAllByType('rect').find(r=>r.props.strokeDasharray==='8 7').props.width;
 assert.ok(text(tree.toJSON()).includes('20x10.5 +36 / 285'));
 await choose(tree,'2024-plus');assert.ok(text(tree.toJSON()).includes('20x10 +45 / 275'));assert.ok(text(tree.toJSON()).includes('+15mm outward'));
 const newWidth=tree.root.findAllByType('rect').find(r=>r.props.strokeDasharray==='8 7').props.width;assert.ok(newWidth>oldWidth, 'rear factory tire drawing must widen for 275mm');
 assert.ok(text(tree.toJSON()).includes('20x10.5 +36 / 285'));
 await act(async()=>window.history.back());assert.equal(selector(tree).props.value,'2017-2023');assert.ok(text(tree.toJSON()).includes('20x9 +34 / 235'));
 await act(async()=>window.history.forward());assert.equal(selector(tree).props.value,'2024-plus');
 const backLink=tree.root.findAllByType('a').find(a=>a.props.href?.startsWith('/fitment?')).props.href;assert.ok(backLink.includes('factoryGeneration=2024-plus'));assert.ok(backLink.includes('style=aggressive'));
 await act(async()=>tree.unmount());
 // Fitment links preserve chosen generation while aftermarket recommendations do not change.
 browser('/fitment?make=Tesla&model=Model+3&trim=Performance&style=aggressive&goal=street&configuration=staggered&factoryGeneration=2017-2023');
 await act(async()=>{tree=create(React.createElement(Fitment))});assert.equal(selector(tree).props.value,'2017-2023');
 let link=tree.root.findAllByType('a').find(a=>a.props.href?.startsWith('/compare?')).props.href;assert.ok(link.includes('factoryGeneration=2017-2023'));assert.ok(link.includes('rearTire=285%2F30R20'));
 assert.ok(!text(tree.toJSON()).includes('Factory default'));
 await choose(tree,'2024-plus');link=tree.root.findAllByType('a').find(a=>a.props.href?.startsWith('/compare?')).props.href;assert.ok(link.includes('factoryGeneration=2024-plus'));assert.ok(link.includes('rearTire=285%2F30R20'));
 await act(async()=>window.history.back());assert.equal(selector(tree).props.value,'2017-2023');await act(async()=>window.history.forward());assert.equal(selector(tree).props.value,'2024-plus');
 await act(async()=>tree.unmount());
 // Unrelated vehicle doesn't get the option or URL flag.
 browser('/compare?make=BMW&model=M4&trim=Base&style=aggressive&factoryGeneration=2017-2023');
 await act(async()=>{tree=create(React.createElement(Compare))});assert.equal(selector(tree),undefined);assert.ok(!tree.root.findAllByType('a').find(a=>a.props.href?.startsWith('/fitment?')).props.href.includes('factoryGeneration'));await act(async()=>tree.unmount());
 browser('/compare?make=Tesla&model=Model+3&trim=Performance&style=aggressive');
 await act(async()=>{tree=create(React.createElement(Compare))});
 await act(async()=>{window.history.pushState(null,'','/compare?make=Unknown&model=Model+3&trim=Performance');window.dispatchEvent({type:'popstate'});});
 assert.equal(selector(tree),undefined);assert.ok(!text(tree.toJSON()).includes('Stock baseline'));
 await act(async()=>tree.unmount());
 assert.equal(model3FactoryBaseline(base,'2017-2023').rearTire,'235/35R20');
 assert.ok(model3ConfigurationHint('square','2017-2023').startsWith('Selected generation'));
 assert.ok(model3ConfigurationHint('staggered','2024-plus').startsWith('Selected generation'));
 console.log('PASS: React route interactions, both generations/axles, unchanged Aggressive handoff, share/back/forward, absent/invalid defaults, unrelated-model isolation, generation-specific factory hint.');
})().catch(err=>{console.error(err);process.exitCode=1});
