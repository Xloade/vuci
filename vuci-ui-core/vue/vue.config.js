const CompressionPlugin = require('compression-webpack-plugin')

module.exports = {
    indexPath: 'vuci.html',
    productionSourceMap: false,
    devServer: {
        proxy: {
            '/rpc': {
                target: 'http://192.168.1.1'
            },
            '/views/': {
                target: 'http://192.168.1.1'
            },
            '/i18n/': {
                target: 'http://192.168.1.1'
            },
            '/upload': {
                target: 'http://192.168.1.1'
            },
            '/download': {
                target: 'http://192.168.1.1n'
            }
        }
    },
    pluginOptions: {
        i18n: {
            locale: 'en',
            fallbackLocale: 'en',
            localeDir: 'locales',
            enableInSFC: false
        }
    },
    configureWebpack: config => {
        if (process.env.NODE_ENV === 'production') {
            return {
                plugins: [new CompressionPlugin({
                    test: /\.js$|\.html$|\.css/,
                    threshold: 4096,
                    deleteOriginalAssets: true,
                    filename: '[path][base]?gz'
                })]
            }
        }
    }
}