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
      title: 'Logging',
      name: 'logging',
      extraInfo: [

      ]
    }
  },
  timers: {
    update: { time: 2000, autostart: true, immediate: true, repeat: true }
  },
  methods: {
    update () {
      this.$rpc.call('system', 'syslog').then(({ log }) => {
        this.extraInfo = log.map((v, i) => {
          return {
            title: v.datetime,
            info: v.msg,
            id: i
          }
        }).slice(-5)
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
