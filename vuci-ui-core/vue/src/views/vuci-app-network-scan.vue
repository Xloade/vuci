<template>
  <div class="example">
    <div class="overlayedArea">
      <Progress v-if="inProgress" :progress="progress"/>
      <ZoomDragViewport ref="zoomViewport" :areaWidth="neededWidth" :areaHeight="neededHeight" excludeClassFromDrag="host">
        <div v-if="subnets.length>0">
          <div class="subnet-discriptions" :style="[{top:`${neededHeight/2-50}px`},{left:`${neededWidth/2+200}px`}]">
            <h1 class="subnet-discription" v-for="subnet in subnets" :key="subnet.discription+'discription'">
              <template>
                {{subnet.discription}}
              </template>
            </h1>
          </div>
          <div class="subnet" v-for="(subnet, subnetIndex) in subnets" :key="subnet.discription">
            <div @mousedown.stop :class="['host',{knownHost:host.knownHost}]" v-for="(host, index) in subnet.hosts" :key="host.ip" :style="getPositionStyle(index, getHostNumFromSubNet(subnet), getOffsetY(subnetIndex))">
              <Host :host="host"/>
            </div>
            <svg class="lines" v-if=subnet.myHost.isInSubnet :style="[{width:`${neededWidth}px`},{height:`${neededHeight}px`}]">
              <line v-for="(host, index) in subnet.hosts" :key="host.ip + '1'"
                :x1="neededWidth/2" :y1="neededHeight/2"
                :x2="getPosition(index, getHostNumFromSubNet(subnet), getOffsetY(subnetIndex)).left"
                :y2="getPosition(index, getHostNumFromSubNet(subnet), getOffsetY(subnetIndex)).top" stroke="black" />
            </svg>
          </div>
          <div class="host myhost" @mousedown.stop :style="[{top:`${neededHeight/2}px`},{left:`${neededWidth/2}px`}]">
            <Host>
              <template v-slot:logo>
                  <RouterSvg/>
              </template>
              <template v-slot:info>
                <div v-for="subnet in subnets" :key="subnet.discription+'my'">
                  <div>{{subnet.discription}}</div>
                  <template v-if=subnet.myHost.isInSubnet>
                    <div>Mac: {{subnet.myHost.mac}}</div>
                    <div>Ip: {{subnet.myHost.ip}}</div>
                  </template>
                  <template v-else-if=!subnet.isSetup>
                    <div :style="{color:'red'}">{{subnet.discription}} not setup</div>
                  </template>
                  <template v-else-if=!subnet.myHost.isConnected>
                    <div :style="{color:'red'}">Disconnected</div>
                  </template>
                  <template v-else>
                    <div :style="{color:'red'}">Not in subnet</div>
                  </template>
                </div>
              </template>
              <template v-slot:info-aditional>
                <div class=""></div>
              </template>
            </Host>
          </div>
        </div>
      </ZoomDragViewport>
    </div>
    <a-button class="btn" type="primary" @click="startScan" :disabled="inProgress">{{$t("buttons.Start")}}</a-button>
    <a-button class="btn" type="danger" @click="stopScan" :disabled="!inProgress">{{$t("buttons.Stop")}}</a-button>
    <a-button class="btn" type="secondary" @click="$refs.zoomViewport.zoomToFit()" :disabled="subnets.length<1">{{$t("buttons.Re center")}}</a-button>
    <a-button class="btn" type="secondary" @click="getResults()">Get result again</a-button>
    <SettingsForm ref="settings"/>
    <KnownHostSettings/>
  </div>
</template>

<script>
import ZoomDragViewport from './ZoomDragViewport'
import RouterSvg from './RouterSvg'
import Progress from './Progress'
import KnownHostSettings from './KnownHostSettings'
import Host from './Host'
import SettingsForm from './SettingsForm'
export default {
  data () {
    return {
      // subnets: [],
      subnets: [{ myHost: { mac: '00:1E:42:27:10:11', vendor: 'OpenWrt', ip: '192.168.10.62' }, discription: 'WAN', hosts: [{ mac: '4C:CC:6A:5F:85:5D', knownHost: false, ports: [{ status: 'closed', port: '22/tcp', service: 'ssh' }, { status: 'closed', port: '64/tcp', service: 'covia' }], vendor: 'Micro-star Intl', ip: '192.168.10.1' }, { mac: '18:C0:4D:3F:24:BD', knownHost: false, ports: [{ status: 'filtered', port: '22/tcp', service: 'ssh' }, { status: 'filtered', port: '64/tcp', service: 'covia' }], vendor: 'Unknown', ip: '192.168.10.101' }, { mac: 'B4:2E:99:14:62:2D', knownHost: false, ports: [{ status: 'filtered', port: '22/tcp', service: 'ssh' }, { status: 'filtered', port: '64/tcp', service: 'covia' }], vendor: 'Unknown', ip: '192.168.10.102' }, { mac: 'E0:D5:5E:26:F4:C2', knownHost: false, ports: [{ status: 'filtered', port: '22/tcp', service: 'ssh' }, { status: 'filtered', port: '64/tcp', service: 'covia' }], vendor: 'Giga-byte Technology', ip: '192.168.10.104' }, { mac: 'D4:5D:64:52:76:A8', knownHost: false, ports: [{ status: 'filtered', port: '22/tcp', service: 'ssh' }, { status: 'filtered', port: '64/tcp', service: 'covia' }], vendor: 'Unknown', ip: '192.168.10.105' }, { mac: '00:D8:61:D8:47:3B', knownHost: false, ports: [{ status: 'filtered', port: '22/tcp', service: 'ssh' }, { status: 'filtered', port: '64/tcp', service: 'covia' }], vendor: 'Unknown', ip: '192.168.10.106' }, { mac: 'B4:2E:99:87:2A:C6', knownHost: false, ports: [{ status: 'filtered', port: '22/tcp', service: 'ssh' }, { status: 'filtered', port: '64/tcp', service: 'covia' }], vendor: 'Unknown', ip: '192.168.10.107' }, { mac: 'B4:2E:99:41:8E:97', knownHost: false, ports: [{ status: 'filtered', port: '22/tcp', service: 'ssh' }, { status: 'filtered', port: '64/tcp', service: 'covia' }], vendor: 'Unknown', ip: '192.168.10.108' }, { mac: '4C:CC:6A:5F:85:8D', knownHost: false, ports: [{ status: 'closed', port: '22/tcp', service: 'ssh' }, { status: 'closed', port: '64/tcp', service: 'covia' }], vendor: 'Micro-star Intl', ip: '192.168.10.13' }, { mac: '00:1E:42:48:34:FD', knownHost: false, ports: [{ status: 'closed', port: '22/tcp', service: 'ssh' }, { status: 'closed', port: '64/tcp', service: 'covia' }], vendor: 'Teltonika', ip: '192.168.10.14' }, { mac: '4C:CC:6A:5F:85:5C', knownHost: false, ports: [{ status: 'closed', port: '22/tcp', service: 'ssh' }, { status: 'closed', port: '64/tcp', service: 'covia' }], vendor: 'Micro-star Intl', ip: '192.168.10.16' }, { mac: '00:1E:42:23:E0:67', knownHost: false, ports: [{ status: 'closed', port: '22/tcp', service: 'ssh' }, { status: 'closed', port: '64/tcp', service: 'covia' }], vendor: 'Teltonika', ip: '192.168.10.17' }, { mac: '00:1E:42:23:96:66', knownHost: false, ports: [{ status: 'open', port: '22/tcp', service: 'ssh' }, { status: 'closed', port: '64/tcp', service: 'covia' }], vendor: 'Teltonika', ip: '192.168.10.187' }, { mac: '00:1E:42:2B:92:3B', knownHost: false, ports: [{ status: 'closed', port: '22/tcp', service: 'ssh' }, { status: 'closed', port: '64/tcp', service: 'covia' }], vendor: 'Teltonika', ip: '192.168.10.254' }, { mac: '00:1E:42:4A:4C:28', knownHost: false, ports: [{ status: 'open', port: '22/tcp', service: 'ssh' }, { status: 'closed', port: '64/tcp', service: 'covia' }], vendor: 'Teltonika', ip: '192.168.10.26' }, { mac: '00:1E:42:22:4C:A7', discription: 'Friendly router', ports: [{ status: 'closed', port: '22/tcp', service: 'ssh' }, { status: 'closed', port: '64/tcp', service: 'covia' }], knownHost: true, vendor: 'Teltonika', ip: '192.168.10.32' }, { mac: '1C:1B:0D:E0:10:67', knownHost: false, ports: [{ status: 'closed', port: '22/tcp', service: 'ssh' }, { status: 'closed', port: '64/tcp', service: 'covia' }], vendor: 'Giga-byte Technology', ip: '192.168.10.34' }, { mac: '1C:1B:0D:E0:67:78', knownHost: false, ports: [{ status: 'closed', port: '22/tcp', service: 'ssh' }, { status: 'closed', port: '64/tcp', service: 'covia' }], vendor: 'Giga-byte Technology', ip: '192.168.10.37' }, { mac: '4C:CC:6A:5F:87:60', knownHost: false, ports: [{ status: 'closed', port: '22/tcp', service: 'ssh' }, { status: 'closed', port: '64/tcp', service: 'covia' }], vendor: 'Micro-star Intl', ip: '192.168.10.4' }, { mac: '00:1E:42:32:AC:2B', knownHost: false, ports: [{ status: 'closed', port: '22/tcp', service: 'ssh' }, { status: 'closed', port: '64/tcp', service: 'covia' }], vendor: 'Teltonika', ip: '192.168.10.45' }, { mac: '1C:1B:0D:E0:60:AF', knownHost: false, ports: [{ status: 'closed', port: '22/tcp', service: 'ssh' }, { status: 'closed', port: '64/tcp', service: 'covia' }], vendor: 'Giga-byte Technology', ip: '192.168.10.49' }, { mac: '1C:1B:0D:E0:67:EF', knownHost: false, ports: [{ status: 'open', port: '22/tcp', service: 'ssh' }, { status: 'filtered', port: '64/tcp', service: 'covia' }], vendor: 'Giga-byte Technology', ip: '192.168.10.55' }, { mac: '1C:1B:0D:9F:F8:0B', knownHost: false, ports: [{ status: 'closed', port: '22/tcp', service: 'ssh' }, { status: 'closed', port: '64/tcp', service: 'covia' }], vendor: 'Giga-byte Technology', ip: '192.168.10.61' }, { mac: '4C:CC:6A:5F:8A:1C', knownHost: false, ports: [{ status: 'closed', port: '22/tcp', service: 'ssh' }, { status: 'closed', port: '64/tcp', service: 'covia' }], vendor: 'Micro-star Intl', ip: '192.168.10.7' }, { mac: '00:1E:42:32:70:6A', knownHost: false, ports: [{ status: 'open', port: '22/tcp', service: 'ssh' }, { status: 'closed', port: '64/tcp', service: 'covia' }], vendor: 'Teltonika', ip: '192.168.10.8' }], subnet: '192.168.10.62/24' }, { myHost: { mac: '00:1E:42:27:10:10', vendor: 'OpenWrt', ip: '192.168.1.1' }, discription: 'LAN', hosts: [{ mac: '18:D6:C7:04:8D:4F', discription: 'My pc', ports: [{ status: 'closed', port: '22/tcp', service: 'ssh' }, { status: 'closed', port: '64/tcp', service: 'covia' }], knownHost: true, vendor: 'Tp-link Technologies', ip: '192.168.1.131' }], subnet: '192.168.1.0/24' }],
      neededHeight: 2000,
      progress: [],
      inProgress: false,
      pingTimeout: null
    }
  },
  methods: {
    startScan () {
      this.$refs.settings.formRef.validate(valid => {
        if (valid) {
          if (this.inProgress) {
            this.stopScan()
          }
          this.$rpc.call('nethosts', 'start', { settings: this.$refs.settings.form }).then((r) => {
            this.inProgress = true
            this.pingTimeout = setTimeout(this.getProgress, 6000)
          })
        }
      })
    },
    getProgress () {
      this.$rpc.call('nethosts', 'progress', { settings: this.$refs.settings.form }).then((r) => {
        this.progress = JSON.parse(r.results)
        let done = true
        console.log(r.results)
        this.progress.forEach(element => {
          if (!element.progress.done) done = false
        })
        if (done) this.getResults()
        else {
          this.pingTimeout = setTimeout(this.getProgress, 5000)
        }
      })
    },
    getResults () {
      this.$rpc.call('nethosts', 'results', { settings: this.$refs.settings.form }).then((r) => {
        this.inProgress = false
        this.subnets = this.sortByIp(JSON.parse(r.hosts))
        console.log(JSON.stringify(this.subnets))
        this.progress = []
      })
    },
    stopScan () {
      if (this.pingTimeout !== null) {
        clearTimeout(this.pingTimeout)
      }
      this.$rpc.call('nethosts', 'stop', {})
      this.progress = []
      this.inProgress = false
    },
    sortByIp (subnets) {
      try {
        subnets.forEach(subnet => {
          subnet.hosts.sort((a, b) => a.ip > b.ip)
        })
      } catch (error) {
        subnets.hosts = []
      }
      return subnets
    },
    getPosition (index, itemCount, offsetY) {
      // const itemAngle = ((finishAngle - startAngle) / (itemCount - 1)) * index
      // const lengthFromCenter = 700
      // const center = { top: 450, left: 1600 }
      // const top = center.top + Math.sin(this.degToRad(itemAngle)) * lengthFromCenter
      // const left = center.left + Math.cos(this.degToRad(itemAngle)) * lengthFromCenter * 2
      const groupWidth = this.widthFromItemCount(itemCount - 1)
      const center = { top: this.neededHeight / 2, left: this.neededWidth / 2 }
      const startLeft = (this.neededWidth / 2 - groupWidth / 2) + 100
      const itemPlace = ((groupWidth - 200) / (itemCount) * index) + startLeft
      const top = center.top - offsetY
      const left = itemPlace
      return {
        top: top,
        left: left
      }
    },
    getPositionStyle (index, itemCount, offsetY) {
      const position = this.getPosition(index, itemCount, offsetY)
      return {
        top: `${position.top}px`,
        left: `${position.left}px`
      }
    },
    degToRad (degrees) {
      var pi = Math.PI
      return degrees * (pi / 180)
    },
    getHostNumFromSubNet (subnet) {
      if (typeof subnet === 'number') return subnet
      return subnet.hosts.length ?? 0
    },
    getOffsetY (index) {
      return index === 0 ? 300 : -300
    },
    widthFromItemCount (count) {
      return count * 200 + 200
    }
  },
  computed: {
    neededWidth () {
      const t = this
      const maxInNet = this.subnets.reduce(function (a, b) {
        return Math.max(t.getHostNumFromSubNet(a), t.getHostNumFromSubNet(b))
      }, -Infinity)
      return this.widthFromItemCount(maxInNet)
    }
  },
  components: {
    ZoomDragViewport,
    RouterSvg,
    Progress,
    KnownHostSettings,
    Host,
    SettingsForm
  }
}
</script>

<style scoped>
  .lines{
    position: absolute;
    top: 0px;
    left: 0px;
    z-index: -1;
  }
  .subnet-discription{
    font-size: 50px;
    margin: 0px;
    padding: 0.5em;
    width: 500px;
    text-align: left;
  }
  .subnet-discription:last-child{
    box-shadow: 0 -10px 5px -2px #888
  }
  .subnet-discription:first-child{
    box-shadow: 0 10px 5px -2px #888;
  }
  .subnet-discriptions{
    position: absolute;
  }
  .overlayedArea{
    position: relative;
  }
  .btn{
    margin: 5px
  }
  .host{
    position: absolute;
  }
</style>
