// Read-only server-rendering regression checks, using fixture fitment pages.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const ts = require('typescript');
const Module = require('node:module');
const React = require('react');
const {renderToStaticMarkup} = require('react-dom/server');
for (const ext of ['.ts', '.tsx']) require.extensions[ext] = (module, filename) => module._compile(ts.transpileModule(fs.readFileSync(filename, 'utf8'), {compilerOptions:{module:ts.ModuleKind.CommonJS,jsx:ts.JsxEmit.ReactJSX,esModuleInterop:true}}).outputText, filename);
const target = '/torque/toyota/5th-gen-4runner';
const originalLoad = Module._load;
Module._load = function(request, parent, isMain) {
  if(request === 'next/link') return ({children, ...props}) => React.createElement('a', props, children);
  if(request.endsWith('/getFitmentSeoPages')) return {
    getFitmentSeoPages: async () => [],
    getFitmentSeoPage: async (make, model) => ({makeSlug:make,modelSlug:model,modelKey:model,makeName:make,modelName:model,urlPath:`/fitment/${make}/${model}`,trims:[]}),
  };
  if(request.endsWith('/getVerifiedTorqueSeoPages')) return {getVerifiedTorqueSeoPages:async()=>[]};
  return originalLoad.call(this, request, parent, isMain);
};
(async () => {
  const page = require('../app/torque/toyota/5th-gen-4runner/page.tsx');
  const html = renderToStaticMarkup(React.createElement(page.default));
  assert.equal(page.metadata.alternates.canonical, target);
  for(const text of ['2019 Toyota 4Runner','2024 Toyota 4Runner','Factory steel wheels','Factory aluminum wheels','112 N·m','103 N·m','Other years are not verified here','2025 4Runner?']) assert.ok(html.includes(text), text);
  for(const [manual,num] of [['OM35B48U',472],['OM35C03U',532]]) assert.ok(html.includes(`${manual}.pdf#page=${num}`));
  assert.ok(html.includes('/torque/toyota/6th-gen-4runner'));
  const fitment = require('../app/fitment/[make]/[model]/page.tsx').default;
  for(const [make,model,expected] of [['toyota','5th-gen-4runner',true],['toyota','6th-gen-4runner',false],['tesla','model-3',false]]) {
    const result = renderToStaticMarkup(await fitment({params:{make,model}}));
    assert.equal(result.includes(target), expected, `${make}/${model} reference scope`);
  }
  const hub = await require('../app/torque/page.tsx').default();
  assert.equal(hub.props.verifiedTorqueLinks[0].href, target);
  assert.ok(hub.props.verifiedTorqueLinks[0].spec.includes('2019 & 2024'));
  const sitemap = await require('../app/sitemap.ts').default();
  assert.equal(sitemap.filter(row=>row.url===`https://offset-lab.com${target}`).length,1);
  console.log('PASS: 4Runner sources, scope, metadata, fitment links, Hub and sitemap');
})().catch(error=>{console.error(error);process.exitCode=1;});
