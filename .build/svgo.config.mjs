export default {
    plugins: [
        'preset-default',
        {
            name: "inlineStyles",
            params: {              
                removeMatchedSelectors: true,
                onlyMatchedOnce: false
            }
        },
        'convertStyleToAttrs',
        'removeStyleElement',
    ],
  };