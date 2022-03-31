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
      title: 'WAN6',
      info: {
        type: {
          title: 'Type',
          info: ''
        },
        ip: {
          title: 'IP adress',
          info: ''
        }
      }
    }
  },
  timers: {
    update: { time: 20000, autostart: true, immediate: true, repeat: true }
  },
  methods: {
    update () {
      this.$network.load()
        .then(() => {
          const network = this.$network.getInterface('wan6')
          this.info.type.info = network.getDevice() ? network.getDevice().name : '-'
          this.info.ip.info = network.getIPv4Addrs()[0] ? network.getIPv4Addrs()[0] : '-'
        })
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
