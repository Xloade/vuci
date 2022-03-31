<template>
  <div>
    <card-layout :title="title" :info="info">
    </card-layout>
  </div>
</template>

<script>
import CardMixin from './CardMixin.vue'
import CardLayout from './CardLayout.vue'
export default {
  data () {
    return {
      title: 'Access control',
      info: {
        lan: {
          title: 'LAN',
          info: ''
        },
        wan: {
          title: 'WAN',
          info: ''
        }
      },
      ssh: {
        local: false,
        wide: false
      },
      http: {
        local: false,
        wide: false
      },
      cli: {
        local: false,
        wide: false
      }
    }
  },
  timers: {
    update: { time: 20000, autostart: true, immediate: true, repeat: true }
  },
  methods: {
    update () {
      const promiseFirewall = this.$uci.load('firewall')
        .then(() => {
          this.$uci.sections('firewall', 'rule').forEach(rule => {
            switch (rule.name) {
              case 'Enable_SSH_WAN':
                this.ssh.wide = rule.enabled === '1'
                break
              case 'Enable_HTTP_WAN':
                this.http.wide = rule.enabled === '1'
                break
              case 'Enable_CLI_WAN':
                this.cli.wide = rule.enabled === '1'
                break
              default:
                break
            }
          })
        })
      const promiseCli = this.$uci.load('cli')
        .then(() => {
          this.cli.local = this.$uci.get('cli', 'status', 'enable') === '1'
        })

      const promiseSsh = this.$uci.load('dropbear')
        .then(() => {
          this.ssh.local = this.$uci.sections('dropbear')[0].enable === '1'
        })

      const promiseHttp = this.$uci.load('vuci-httpd')
        .then(() => {
          this.http.local = this.$uci.get('vuci-httpd', 'main', 'enabled') === '1'
        })
      Promise.all([promiseFirewall, promiseCli, promiseSsh, promiseHttp])
        .then(() => {
          this.setInfo()
        })
    },
    setInfo () {
      this.info.lan.info = ''
      if (this.ssh.local) this.info.lan.info += 'ssh, '
      if (this.http.local) this.info.lan.info += 'http, '
      if (this.cli.local) this.info.lan.info += 'cli, '
      this.info.wan.info = ''
      if (this.ssh.wide) this.info.wan.info += 'ssh, '
      if (this.http.wide) this.info.wan.info += 'http, '
      if (this.cli.wide) this.info.wan.info += 'cli, '

      if (this.info.lan.info.length > 1) {
        this.info.lan.info = this.info.lan.info.slice(0, -2)
      } else {
        this.info.lan.info = '-'
      }
      if (this.info.wan.info.length > 1) {
        this.info.wan.info = this.info.wan.info.slice(0, -2)
      } else {
        this.info.wan.info = '-'
      }
    }
  },
  mixins: [CardMixin],
  components: {
    CardLayout
  }
}
</script>

<style lang="scss" scoped>

</style>
