<template>
  <div>
    <a-row class="server-info" type="flex" justify="center" align="middle">
      <a-col>
        <h2>Server:
          <span class="noServer" v-if="noServer">No server found</span>
          <template v-else>{{server.Provider}}</template>
        </h2>
      </a-col>
      <a-col>
        <h2>Ping: {{ping.toFixed(2)}}ms</h2>
      </a-col>
    </a-row>
    <a-row class="avg-speeds" type="flex" justify="center" align="middle">
      <a-col>
        <h2>Download: {{averageDown.toFixed(2)}}
          <template v-if="!isNaN(averageDown)">Mbps</template>
        </h2>
      </a-col>
      <a-col>
        <h2>Upload: {{averageUp.toFixed(2)}}
          <template v-if="!isNaN(averageDown)">Mbps</template>
        </h2>
      </a-col>
    </a-row>
    <a-row type="flex" justify="space-around" align="middle">
      <a-col>
        <speed-dial :DownResults="DownResults" :UpResults="UpResults" />
      </a-col>
    </a-row>
    <a-row type="flex" justify="space-around" align="middle">
      <a-col :span="6">
        <a-button type="primary" @click="Start()" :disabled="testing" block>Start speed test</a-button>
      </a-col>
    </a-row>
  </div>
</template>

<script>
import SpeedDial from './SpeedDial.vue'
export default {
  data () {
    return {
      server: {},
      ping: 0,
      DownResults: [],
      UpResults: [],
      testing: false,
      noServer: false
    }
  },
  methods: {
    Start () {
      this.server = {}
      this.ping = 0
      this.DownResults = []
      this.UpResults = []
      this.testing = true
      this.noServer = false
      this.$rpc.call('speedtest', 'GetServer', { })
        .then(this.HandleGetServer, this.HandleNoServer)
        .then(() => { return this.$rpc.call('speedtest', 'GetPing', { host: this.server.Host }) })
        .then(this.HandleGetPing)
        .then(async () => {
          await [...Array(3)].reduce((p, _, i) => {
            return p.then(() => { return this.$rpc.call('speedtest', 'Download', { host: this.server.Host }) })
              .then(this.HandleTestDown)
          }
          , Promise.resolve())
        })
        .then(async () => {
          await [...Array(3)].reduce((p, _, i) => {
            return p.then(() => { return this.$rpc.call('speedtest', 'Upload', { host: this.server.Host }) })
              .then(this.HandleTestUp)
          }
          , Promise.resolve())
        })
        .then(() => { this.testing = false })
    },
    HandleGetServer (result) {
      this.server = result.server
    },
    HandleGetPing (result) {
      this.ping = result.result
    },
    HandleTestDown (result) {
      this.DownResults.push(result.result)
    },
    HandleTestUp (result) {
      this.UpResults.push(result.result)
    },
    HandleNoServer (result) {
      this.noServer = true
      this.testing = false
    }
  },
  computed: {
    averageDown () {
      const sum = this.DownResults.reduce((curr, sum) => sum + curr, 0)
      return sum / this.DownResults.length
    },
    averageUp () {
      const sum = this.UpResults.reduce((curr, sum) => sum + curr, 0)
      return sum / this.UpResults.length
    }
  },
  components: {
    SpeedDial
  }
}
</script>

<style scoped>
  .avg-speeds h2, .server-info h2{
    padding: 20px;
  }
  .noServer{
    color: red;
  }
</style>
