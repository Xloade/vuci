<template>
  <div>
    <card-layout :title="title" :combinedInfo="combinedInfo">
    </card-layout>
  </div>
</template>

<script>
import CardMixin from './CardMixin.vue'
import CardLayout from './CardLayout.vue'
export default {
  data () {
    return {
      title: 'LAN',
      name: 'lan',
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
    update: { time: 2000, autostart: true, immediate: true, repeat: true }
  },
  methods: {
    update () {
      this.$network.load()
        .then(() => {
          const network = this.$network.getInterface('lan')
          this.info.type.info = network.getDevice().name
          this.info.ip.info = network.getIPv4Addrs()[0]
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
