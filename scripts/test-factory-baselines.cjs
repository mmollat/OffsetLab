// Offline regression tests: no live database, credentials, or production writes.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const ts = require('typescript');
const Module = require('node:module');
for (const ext of ['.ts', '.tsx']) require.extensions[ext] = (module, filename) => {
  module._compile(ts.transpileModule(fs.readFileSync(filename, 'utf8'), {
    compilerOptions: { module: ts.ModuleKind.CommonJS, jsx: ts.JsxEmit.ReactJSX, esModuleInterop: true }
  }).outputText, filename);
};
const { factoryTireLabel } = require('../app/lib/factoryTires.ts');
assert.equal(factoryTireLabel('235/35R20', '235/35R20'), '235/35R20');
const identity = { make: 'Tesla', model: 'Model 3', trim: 'Performance', active: true };
const base = { ...identity, front: '20x9 +34', rear: '20x10 +45', tire: '235/35R20 front / 275/30R20 rear', front_tire: '235/35R20', rear_tire: '275/30R20', is_default: true, package_name: '2024+', market: 'US' };
const older = { ...base, rear: '20x9 +34', rear_tire: '235/35R20', tire: '235/35R20', is_default: false, package_name: '2017–2023', source_status: 'verified' };
let tables = {
  fitment_factory_baselines: [],
  fitment_preset_variants: [],
  fitment_presets: [{ ...identity, style: 'oemplus', front: '20x9 +34', rear: '20x10 +45', front_tire: '235/35R20', rear_tire: '275/30R20' }]
};
let axle = 'front';
let routeStates = [];
let stateIndex = 0;
let seoPage;
const react = require('react');
const originalLoad = Module._load;
Module._load = function(request, parent, isMain) {
  if (request === 'next/link') return ({children, ...props}) => react.createElement('a', props, children);
  if (request.endsWith('/getFitmentSeoPages')) return { getFitmentSeoPage: async () => seoPage };
  if (parent?.filename.endsWith('/fitment/page.tsx') && /components\//.test(request)) return () => null;
  if (request === 'react' && (parent?.filename.endsWith('/compare/page.tsx') || parent?.filename.endsWith('/fitment/page.tsx'))) return {
    ...react, useEffect: () => {}, useMemo: fn => fn(), useState: () => [routeStates[stateIndex++], () => {}]
  };
  if (request === './supabase') return { supabase: { from(name) {
    let rows = tables[name];
    const q = { select: () => q, eq: (key,value) => { rows = rows.filter(r => r[key] === value); return q; }, order: () => q, range: () => q,
      then: resolve => Promise.resolve({data: rows, error: null}).then(resolve) };
    return q;
  }}};
  if (request === 'react' && parent?.filename.endsWith('CompareFitmentVisual.tsx')) return {
    ...react, useEffect: () => {}, useMemo: fn => fn(), useState: initial => [initial === 'front' ? axle : initial, () => {}]
  };
  return originalLoad.call(this, request, parent, isMain);
};
(async () => {
  const { getFitmentData } = require('../app/lib/getFitmentData.ts');
  let trim = (await getFitmentData())['Model 3'][0];
  assert.equal(trim.baseline.rearTire, '275/30R20');
  const Visual = require('../app/components/CompareFitmentVisual.tsx').default;
  const { renderToStaticMarkup } = require('react-dom/server');
  for (const baseline of [trim.baseline, { ...trim.baseline, rear: '20x9 +34', rearTire: '235/35R20' }]) {
    for (axle of ['front', 'rear']) {
      const html = renderToStaticMarkup(Visual({baselineFront: baseline.front, baselineRear: baseline.rear,
        baselineTire: baseline.frontTire, baselineRearTire: baseline.rearTire,
        selectedFront: baseline.front, selectedRear: baseline.rear,
        selectedTire: baseline.frontTire, selectedRearTire: baseline.rearTire}));
      assert.ok(!html.includes('NaN'));
      assert.ok(html.includes('0mm'));
      if (axle === 'rear' && baseline.rearTire === '275/30R20') assert.ok(html.includes('20x10 +45 / 275'), 'rear visual uses factory rear width, not front width');
    }
  }
  tables.fitment_factory_baselines = [];
  trim = (await getFitmentData())['Model 3'][0];
  assert.equal(trim.baseline.rearTire, '275/30R20', 'OEM+ fallback retains rear tire');
  assert.ok(trim.baseline.note.includes('2024+'));
  const models = [{make: 'Tesla', model: 'Model 3', active: true}];
  const trims = [{make: 'Tesla', model: 'Model 3', trim: 'Performance', active: true}];
  const preset = { ...trim.presets.oemplus, title: 'OEM+', verdict: 'Test setup', risk: 'Low', warnings: [], daily: 8, aggression: 2 };
  trim.presets = {oemplus: preset, flush: preset, aggressive: preset};
  const db = {'Model 3': [trim]};
  const ComparePage = require('../app/compare/page.tsx').default;
  routeStates = ['Tesla', 'Model 3', 'Performance', 'oemplus', db, models, trims, null, {goal:'street', configuration:'staggered'}];
  stateIndex = 0;
  const compareHtml = renderToStaticMarkup(ComparePage());
  assert.ok(compareHtml.includes('275/30R20'));
  assert.ok(compareHtml.includes('2024+'));
  assert.ok(compareHtml.includes('not an older-year stock comparison'));
  const FitmentPage = require('../app/fitment/page.tsx').default;
  routeStates = ['Tesla', 'Model 3', 'Performance', 'oemplus', 'street', 'staggered', false, false, [], db, models, trims];
  stateIndex = 0;
  const fitmentHtml = renderToStaticMarkup(FitmentPage());
  assert.ok(fitmentHtml.includes('not an older-year stock comparison'));
  assert.ok(fitmentHtml.includes('/compare?make=Tesla'));
  seoPage = { makeName: 'Tesla', modelName: 'Model 3', makeSlug:'tesla', modelKey:'Model 3', urlPath:'/fitment/tesla/model-3', trims: [{trim:'Performance', baselineFront:trim.baseline.front, baselineRear:trim.baseline.rear, baselineTire: factoryTireLabel(trim.baseline.frontTire,trim.baseline.rearTire), baselineNote:trim.baseline.note, presets:[{...preset, style:'oemplus', label:'OEM+'}]}] };
  const Guide = require('../app/fitment/[make]/[model]/page.tsx').default;
  const guideHtml = renderToStaticMarkup(await Guide({params:{make:'tesla',model:'model-3'}}));
  assert.ok(guideHtml.includes('235/35R20 front / 275/30R20 rear'));
  assert.ok(guideHtml.includes('2017–2023'));
  assert.ok(guideHtml.includes('square 20x9 +34'));
  tables.fitment_presets[0].factory_tire = '235/35R20';
  trim = (await getFitmentData())['Model 3'][0];
  assert.equal(trim.baseline.frontTire, trim.baseline.rearTire);
  tables.fitment_presets[0] = { ...tables.fitment_presets[0], make: 'BMW', model: 'M4', factory_tire: null };
  trim = (await getFitmentData()).M4[0];
  assert.equal(trim.baseline.rearTire, trim.baseline.tire, 'unrelated OEM+ fallback unchanged');
  assert.equal(trim.baseline.note, undefined);
  const compare = fs.readFileSync(path.join(__dirname, '../app/compare/page.tsx'), 'utf8');
  assert.ok(compare.includes('baselineRearTire={trimData.baseline.rearTire}'));
  assert.ok(!compare.includes("factoryPackage"));
  console.log('PASS: helper formatting, scoped Model 3 fallback, unrelated/square regressions, both visual axles/generations, legacy loader, unchanged URL wiring; mocked Guide/Fitment/Compare route rendering and scoped year warnings.');
})().catch(err => { console.error(err); process.exitCode = 1; });
