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
      title: 'Recent network events',
      info: [

      ]
    }
  },
  timers: {
    update: { time: 20000, autostart: true, immediate: true, repeat: true }
  },
  methods: {
    update () {
      this.$rpc.call('mainpage', 'logs', { msg: { type: 'NETWORK', short: true } }).then(({ log }) => {
        this.info = log.map((v, i) => {
          return {
            title: v.datetime,
            info: v.event,
            id: i
          }
        })
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
