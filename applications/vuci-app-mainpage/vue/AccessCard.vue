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
      }
    }
  },
  timers: {
    update: { time: 20000, autostart: true, immediate: true, repeat: true }
  },
  methods: {
    update () {
      this.$rpc.call('mainpage', 'Access').then(({ lan, wan }) => {
        this.info.lan.info = lan
        this.info.wan.info = wan
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
