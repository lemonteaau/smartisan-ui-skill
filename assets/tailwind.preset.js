/**
 * Smartisan OS UI — Tailwind CSS preset (v3 `presets: [...]`; for v4 copy the
 * values into an `@theme` block). Values mirror assets/smartisan.css / tokens.json.
 * Component styling still lives in smartisan.css; this preset gives you the
 * tokens as utilities (bg-s-grey-100, rounded-s-lg, shadow-s-card, ...).
 */
module.exports = {
  theme: {
    extend: {
      colors: {
        s: {
          white: '#ffffff',
          grey: { 100: '#fafafa', 200: '#f2f2f2', 300: '#eeeeee', 400: '#e2e2e2', 500: '#bababa', 600: '#9d9d9d', 700: '#7f7f7f', 800: '#636363', 900: '#333333' },
          blue: { 100: '#e7edfd', 300: '#5985eb', 400: '#5079d9', 500: '#3f68e2', 600: '#2f54d7', pressed: '#4772e6', top: '#5b87eb', bottom: '#5883eb' },
          page: '#f5f5f5',
          'page-real': '#f0f0f0',
          'sheet-body': '#efefef',
          'dialog-action': '#f7f7f7',
          'dialog-action-pressed': '#dfdfdf',
          'dialog-action-text': '#5e80d0',
          'appbar-border': '#d8d8d8',
          red: { top: '#cd3f3a', bottom: '#c83530', border: '#b7241f', icon: '#e5645a', stroke: '#da463e' },
          text: { body: '#656565', desc: '#797979', placeholder: '#d9d9d9' },
          icon: { DEFAULT: '#929292', disabled: '#c7c7c7', chevron: '#b2b2b2', blue: '#5c89f2' },
          toast: { top: '#fcf6e6', bottom: '#fcf3dc', border: '#d2b89c', text: '#ad8a67' },
          chip: {
            'white-bg': '#fafafa', 'white-border': '#cecece', 'white-text': '#646464',
            'yellow-bg': '#fff5d9', 'yellow-border': '#ccb08c', 'yellow-text': '#cd9143',
            'blue-border': '#93b2f7', 'blue-text': '#6393ff',
            'red-bg': '#ffe7e5', 'red-border': '#eb7f77', 'red-text': '#cc3e39',
            'grey-bg': '#f0f0f0', 'grey-border': '#dadada'
          }
        }
      },
      backgroundImage: {
        's-primary': 'linear-gradient(180deg,#5b87eb,#5883eb)',
        's-white': 'linear-gradient(180deg,#ffffff,#fcfcfc)',
        's-white-pressed': 'linear-gradient(180deg,#ebebeb,#f2f2f2)',
        's-red': 'linear-gradient(180deg,#e5645a,#e55f55)',
        's-appbar-red': 'linear-gradient(180deg,#cd3f3a,#c83530)',
        's-segment': 'linear-gradient(180deg,#4878f0,#6997f4)',
        's-sheet-header': 'linear-gradient(180deg,#ffffff,#fafafa)',
        's-toast': 'linear-gradient(180deg,#fcf6e6,#fcf3dc)',
        's-icon': 'linear-gradient(180deg,#8c8c8c,#989898)',
        's-kit-header': 'linear-gradient(90deg,#222325 0%,#3b3c3f 49%,#222325 100%)'
      },
      borderRadius: { 's-segment': '3px', 's-sm': '4px', 's-md': '6px', 's-sheet-btn': '8px', 's-lg': '10px', 's-dialog': '12px', 's-sheet': '20px', 's-kit': '40px', 's-pill': '100px' },
      borderWidth: { 's-xs': '0.4px', 's-sm': '0.5px', 's-md': '0.8px' },
      boxShadow: {
        's-card': '0 10px 16px rgba(0,0,0,0.04)',
        's-card-sm': '0 2px 6px rgba(0,0,0,0.06)',
        's-bar': '0 4px 4px rgba(0,0,0,0.08)',
        's-knob': '0 5px 16.6px rgba(0,0,0,0.21)',
        's-knob-sm': '0 4px 4px rgba(0,0,0,0.12)',
        's-thumb': '0 4px 4px rgba(0,0,0,0.08)',
        's-slider-thumb': '0 4px 8px rgba(0,0,0,0.16)',
        's-inset-track': 'inset 0 4px 4px rgba(0,0,0,0.06)',
        's-inset-switch': 'inset 0 4px 12px rgba(0,0,0,0.10)',
        's-inset-well': 'inset 0 4px 12px rgba(0,0,0,0.18)',
        's-inset-field': 'inset 0 4px 4px rgba(0,0,0,0.04)',
        's-inset-tab': 'inset 0 4px 10px rgba(0,0,0,0.06)',
        's-inset-swipe': 'inset 0 0 4px rgba(0,0,0,0.16)'
      },
      dropShadow: {
        's-btn': '0 4px 2px rgba(0,0,0,0.10)',
        's-dialog-actions': '0 4px 2.1px rgba(0,0,0,0.07)',
        's-bar': '0 4px 4px rgba(0,0,0,0.08)'
      },
      fontFamily: { s: ['Smartisan Compact', 'Inter', '-apple-system', 'BlinkMacSystemFont', 'PingFang SC', 'Noto Sans CJK SC', 'Source Han Sans SC', 'Hiragino Sans GB', 'Noto Sans SC', 'Microsoft YaHei', 'sans-serif'] },
      fontSize: { 's-nav': '8px', 's-12': '12px', 's-14': '14px', 's-16': '16px', 's-18': '18px', 's-48': '48px' },
      spacing: { 's-screen': '432px', 's-row': '60px', 's-bar': '48px', 's-action': '54px' }
    }
  }
};
