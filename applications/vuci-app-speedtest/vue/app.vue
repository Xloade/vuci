<template>
  <div>
    <a-row class="server-info" type="flex" justify="center" align="middle">
      <!-- <a-col>
        <h2>Server:
          <span class="noServer" v-if="noServer">No server found</span>
          <template v-else>{{server.Provider}}</template>
        </h2>
      </a-col> -->
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
      <a-col>
        <a-form-model :model="form" ref="form" :label-col="{span:6}" :wrapper-col="{span:14}">
          <a-form-model-item :label="$t('server')" prop="server" :rules="rules.required">
            <a-select
              show-search
              placeholder="Select a person"
              option-filter-prop="children"
              style="width: 200px"
              :filter-option="serverFilter"
              :options="ServerSelectOptions"
              v-model="form.server"
            >
            </a-select>
          </a-form-model-item >
        </a-form-model>
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
export default {
  data () {
    return {
      servers: [],
      form: {
        server: null
      },
      locationInfo: '',

      ping: 0,
      DownResults: [],
      UpResults: [],
      testing: false,
      noServer: false,
      rules: {
        required: [
          { required: true, message: this.$t('invalid.required'), trigger: 'blur' }
        ]
      }
    }
  },
  methods: {
    serverFilter (input, option) {
      return (
        option.componentOptions.children[0].text.toLowerCase().indexOf(input.toLowerCase()) >= 0
      )
    },
    BtnStart () {
      this.$refs.form.validate(valid => {
        if (valid) {
          this.Start()
        }
      })
    },
    Start () {
      this.server = {}
      this.ping = 0
      this.DownResults = []
      this.UpResults = []
      this.testing = true
      this.noServer = false
      this.$rpc.call('speedtest', 'GetPing', { host: this.selectedServer.Host })
        .then(this.HandleGetPing)
        .then(async () => {
          await [...Array(3)].reduce((p, _, i) => {
            return p.then(() => { return this.$rpc.call('speedtest', 'Download', { host: this.selectedServer.Host }) })
              .then(this.HandleTestDown)
          }
          , Promise.resolve())
        })
        .then(async () => {
          await [...Array(3)].reduce((p, _, i) => {
            return p.then(() => { return this.$rpc.call('speedtest', 'Upload', { host: this.selectedServer.Host }) })
              .then(this.HandleTestUp)
          }
          , Promise.resolve())
        })
        .then(() => { this.testing = false })
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
                this.form.server = server.ID
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
    ServerSelectOptions () {
      return this.servers.map((value) => {
        return {
          label: value.Provider,
          value: value.ID
        }
      })
    },
    selectedServer () {
      return this.servers.find((element) => element.ID === this.form.server)
    }
  },
  created () {
    this.GetServers()
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
