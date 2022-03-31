<template>
  <div>
    <card-layout :title="title" :info="info">
      <template #title-additional>
        <memory-usage-info :info="cpuPercentage" />
      </template>
    </card-layout>
  </div>
</template>

<script>
import CardMixin from './CardMixin.vue'
import CardLayout from './CardLayout.vue'
import MemoryUsageInfo from './MemoryUsageInfo.vue'
export default {
  data () {
    return {
      title: 'System',
      cpuPercentage: [{
        title: 'CPU usage',
        info: 0
      }],
      lastCPUTime: null,
      info: {
        uptime: {
          title: 'Uptime',
          info: ''
        },
        localTime: {
          title: 'Local time',
          info: ''
        },
        version: {
          title: 'Firmware version',
          info: ''
        },
        memoryUsage: {
          title: 'Memory usage',
          type: 'memory-usage-info',
          info: {
            ram: {
              title: 'RAM:',
              info: 0
            },
            flash: {
              title: 'FLASH:',
              info: 0
            }
          }
        }
      }
    }
  },
  timers: {
    update: { time: 2000, autostart: true, immediate: true, repeat: true },
    updateCpuUsage: { time: 1000, autostart: true, immediate: true, repeat: true }
  },
  methods: {
    update () {
      this.$system.getInfo().then(({ hostname, model, system, release, kernel, localtime, uptime, memory }) => {
        this.info.uptime.info = '%t'.format(uptime)
        this.info.localTime.info = new Date(localtime * 1000).toLocaleString()
        this.info.version.info = release.revision
        this.info.uptime.info = '%t'.format(uptime)

        this.info.memoryUsage.info.ram.info = Math.floor(((memory.total - memory.free) / memory.total) * 100)
      })

      this.$system.getDiskInfo().then(({ root }) => {
        this.info.memoryUsage.info.flash.info = Math.floor((root.used / root.total) * 100)
      })
    },
    updateCpuUsage () {
      this.$rpc.call('system', 'cpu_time').then(times => {
        if (!this.lastCPUTime) {
          this.cpuPercentage[0].info = 0
          this.lastCPUTime = times
          return
        }

        const idle1 = this.lastCPUTime[3]
        const idle2 = times[3]

        let total1 = 0
        let total2 = 0

        this.lastCPUTime.forEach(t => {
          total1 += t
        })

        times.forEach(t => {
          total2 += t
        })

        this.cpuPercentage[0].info = Math.floor(((total2 - total1 - (idle2 - idle1)) / (total2 - total1)) * 100)
        this.lastCPUTime = times
      })
    }
  },
  mixins: [CardMixin],
  components: {
    CardLayout,
    MemoryUsageInfo
  }
}
</script>

<style lang="scss" scoped>

</style>
