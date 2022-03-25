<template>
  <div>
    <a-row class="server-info" type="flex" justify="center" align="middle" :gutter="[100, 0]">
      <a-col v-if="locationInfo">
        <div class="info">
          <location-svg class="icon"/>
          <h2>Location: {{locationInfo.country}}</h2>
        </div>
      </a-col>
      <a-col>
        <div class="info">
          <clock-svg class="icon"/>
          <h2>Ping: {{ping.toFixed(2)}}ms</h2>
        </div>
      </a-col>
    </a-row>
    <a-row class="avg-speeds" type="flex" justify="center" align="middle" :gutter="[100, 0]">
      <a-col>
        <div class="speeds">
          <download-svg class="icon download"/>
          <h2>
              Download: {{averageDown.toFixed(2)}}
            <template v-if="!isNaN(averageDown)">Mbps</template>
          </h2>
        </div>
      </a-col>
      <a-col>
        <div class="speeds">
          <upload-svg class="icon upload"/>
          <h2>
            Upload: {{averageUp.toFixed(2)}}
            <template v-if="!isNaN(averageDown)">Mbps</template>
          </h2>
        </div>
      </a-col>
    </a-row>
    <a-row type="flex" justify="space-around" align="middle">
      <a-col>
        <speed-dial :DownResults="DownResults" :UpResults="UpResults" />
      </a-col>
    </a-row>
    <a-row class="select" type="flex" justify="center" align="middle">
      <a-col :span="2">
        Test progress:
      </a-col>
      <a-col :span="6">
        <a-progress class="test-progress" :percent="testStatus.percent" :status="testStatus.status">
          <template #format>
            {{testStatus.message}}
          </template>
        </a-progress>
      </a-col>
    </a-row>
    <a-row class="select" type="flex" justify="space-around" align="middle">
      <a-col :span="6">
        <server-select :list="servers" :selected="server" @select="(e) => server = e"/>
          <p style="color: red;" v-if="!server && showWarn">Please select server</p>
      </a-col>
    </a-row>
    <a-row type="flex" justify="space-around" align="middle">
      <a-col :span="6">
        <a-button type="primary" @click="BtnStart()" :disabled="testing" block>Start speed test</a-button>
      </a-col>
    </a-row>
  </div>
</template>

<script>
import SpeedDial from './SpeedDial.vue'
import ServerSelect from './ServerSelect.vue'
import DownloadSvg from './DownloadSvg.vue'
import UploadSvg from './UploadSvg.vue'
import LocationSvg from './LocationSvg.vue'
import ClockSvg from './ClocSvg.vue'
export default {
  data () {
    return {
      servers: [],
      server: null,
      locationInfo: '',
      showWarn: false,

      ping: 0,
      DownResults: [],
      UpResults: [],
      testing: false,
      testFailed: false
    }
  },
  methods: {
    serverFilter (input, option) {
      return (
        option.componentOptions.children[0].text.toLowerCase().indexOf(input.toLowerCase()) >= 0
      )
    },
    BtnStart () {
      if (this.server) {
        this.Start()
      } else {
        this.showWarn = true
      }
    },
    Start () {
      this.ping = 0
      this.DownResults = []
      this.UpResults = []
      this.testing = true
      this.testFailed = false

      return this.$rpc.call('speedtest', 'HelloServer', { server: this.server.Host })
        .then(() => { return this.HandleHello })
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
        .catch(this.HandleTestFailed)
    },
    HandleHello (result) {
      return new Promise((resolve, reject) => {
        if (result === 200) {
          resolve()
        } else {
          reject(new Error('not 200'))
        }
      })
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
    HandleTestFailed (result) {
      console.log(result)
      this.testFailed = true
      this.testing = false
    },
    GetServers () {
      this.$rpc.call('speedtest', 'GetServers', { })
        .then((result) => {
          this.servers = result.servers.Servers
        })
        .then(this.AutoSelectServer)
    },
    async AutoSelectServer () {
      await this.$rpc.call('speedtest', 'GetLocationInfo', { })
        .then((result) => {
          this.locationInfo = result.info
        })
      const servers = this.servers.filter((value) => value.Country === this.locationInfo.country)
      try {
        await servers.reduce((p, server, i) => {
          return p.then(() => {
            return this.$rpc.call('speedtest', 'HelloServer', { server: server.Host })
          })
            .then((result) => {
              if (result.response === 200) {
                this.server = server
                throw new Error('Done')
              }
            })
        }, Promise.resolve())
      } catch (error) {
        console.log(error.message)
      }
    },
    GetServerHost (server) {
      const resArr = new RegExp('(.+)/upload.php').exec(server['@url'])
      if (resArr.length < 1) {
        return ''
      } else {
        return resArr[1]
      }
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
    },
    testStatus () {
      if (this.testFailed) {
        return { message: 'failed', percent: 100, status: 'exception' }
      } else if (this.testing) {
        if (!this.DownResults.length) {
          return { message: 'ping', percent: 30, status: 'active' }
        } else if (!this.UpResults.length) {
          return { message: 'download', percent: 60, status: 'active' }
        } else {
          return { message: 'upload', percent: 90, status: 'active' }
        }
      } else if (this.ping) {
        return { message: 'finished', percent: 100, status: 'success' }
      } else {
        return { message: 'not started', percent: 0, status: 'normal' }
      }
    }
  },
  created () {
    this.GetServers()
  },
  components: {
    SpeedDial,
    ServerSelect,
    DownloadSvg,
    UploadSvg,
    ClockSvg,
    LocationSvg
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
  .select{
    margin: 12px 0px
  }
  .speeds > *:last-child , .info > *:last-child {
    display: inline;
    margin-bottom: 0px;
  }
  .speeds, .info{
    display: flex;
    align-items: center;
  }
</style>
<style>
  svg.icon.download{
    fill:blue
  }
  svg.icon.upload{
    fill:green
  }
</style>
