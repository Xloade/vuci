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
      title: 'WAN',
      name: 'wan',
      info: {
        type: {
          title: 'Type',
          info: ''
        },
        failover: {
          title: 'Failover',
          info: 'REIKIA PAZIURETI !!!'
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
          const network = this.$network.getInterface('wan')
          this.info.type.info = network.getDevice().name
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
