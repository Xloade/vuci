<template>
  <div class="example">
    <ZoomDragViewport :showInner="subnets.length>0" :areaWidth="neededWidth" :areaHeight="neededHeight" excludeClassFromDrag="host">
      <div class="subnet" v-for="(subnet, subnetIndex) in subnets" :key="subnet.discription">
        <div @mousedown.stop class="host" v-for="(host, index) in subnet.hosts" :key="host.ip" :style="getPositionStyle(index, getHostNumFromSubNet(subnet), getOffsetY(subnetIndex))">
          <div class="box">
            <RouterSvg v-if="host.vendor=='Teltonika'"/>
            <DesktopSvg v-else/>
          </div>
          <div class="info">
            <div>Ip: {{host.ip}}</div>
            <div>Mac: {{host.mac}}</div>
          </div>
          <div class="info aditional-info">
            <div>Vendor: {{host.vendor}}</div>
          </div>
        </div>
        <svg class="lines" :style="[{width:`${neededWidth}px`},{height:`${neededHeight}px`}]">
          <line v-for="(host, index) in subnet.hosts" :key="host.ip + '1'"
            :x1="neededWidth/2" :y1="neededHeight/2"
            :x2="getPosition(index, getHostNumFromSubNet(subnet), getOffsetY(subnetIndex)).left"
            :y2="getPosition(index, getHostNumFromSubNet(subnet), getOffsetY(subnetIndex)).top" stroke="black" />
        </svg>
      </div>
      <div class="host myhost" @mousedown.stop :style="[{top:`${neededHeight/2}px`},{left:`${neededWidth/2}px`}]">
        <div class="box">
            <RouterSvg/>
          </div>
        <div class="info" v-for="subnet in subnets" :key="subnet.discription+'my'">
          <div>{{subnet.discription}}</div>
          <div>Mac: {{subnet.myHost.mac}}</div>
          <div>Ip: {{subnet.myHost.ip}}</div>
        </div>
        <div class="info aditional-info">
          <div>Vendor: {{subnets[0].myHost.vendor}}</div>
        </div>
      </div>
    </ZoomDragViewport>
    <a-button type="primary" @click="get_subnets">{{$t("Examples")}}</a-button>
  </div>
</template>

<script>
import ZoomDragViewport from './ZoomDragViewport'
import RouterSvg from './RouterSvg'
import DesktopSvg from './DesktopSvg'
export default {
  data () {
    return {
      // subnets: [],
      subnets: [{ myHost: { mac: '00:1E:42:27:10:11', vendor: 'OpenWrt', ip: '192.168.10.62' }, discription: 'WAN', hosts: [{ mac: '4C:CC:6A:5F:85:5D', knownHost: false, vendor: 'Micro-star Intl', ip: '192.168.10.1' }, { mac: '00:1E:42:4C:08:13', knownHost: false, vendor: 'Teltonika', ip: '192.168.10.2' }, { mac: '4C:CC:6A:5F:8A:1C', knownHost: false, vendor: 'Micro-star Intl', ip: '192.168.10.7' }, { mac: '00:1E:42:32:70:6A', knownHost: false, vendor: 'Teltonika', ip: '192.168.10.8' }, { mac: '4C:CC:6A:5F:85:8D', knownHost: false, vendor: 'Micro-star Intl', ip: '192.168.10.13' }, { mac: '00:1E:42:48:34:FD', knownHost: false, vendor: 'Teltonika', ip: '192.168.10.14' }, { mac: '4C:CC:6A:5F:85:5C', knownHost: false, vendor: 'Micro-star Intl', ip: '192.168.10.16' }, { mac: '00:1E:42:23:E0:67', knownHost: false, vendor: 'Teltonika', ip: '192.168.10.17' }, { mac: '00:1E:42:4A:4C:28', knownHost: false, vendor: 'Teltonika', ip: '192.168.10.26' }, { mac: '1C:1B:0D:E0:15:14', knownHost: false, vendor: 'Giga-byte Technology', ip: '192.168.10.31' }, { mac: '1C:1B:0D:E0:10:67', knownHost: false, vendor: 'Giga-byte Technology', ip: '192.168.10.34' }, { mac: '1C:1B:0D:E0:67:78', knownHost: false, vendor: 'Giga-byte Technology', ip: '192.168.10.37' }, { mac: '00:1E:42:32:AC:2B', knownHost: false, vendor: 'Teltonika', ip: '192.168.10.45' }, { mac: '1C:1B:0D:E0:67:7A', knownHost: false, vendor: 'Giga-byte Technology', ip: '192.168.10.46' }, { mac: '1C:1B:0D:9F:F8:0B', knownHost: false, vendor: 'Giga-byte Technology', ip: '192.168.10.61' }, { mac: '18:C0:4D:3F:24:BD', knownHost: false, vendor: 'Unknown', ip: '192.168.10.101' }, { mac: 'B4:2E:99:14:62:2D', knownHost: false, vendor: 'Unknown', ip: '192.168.10.102' }, { mac: 'D4:5D:64:52:76:A8', knownHost: false, vendor: 'Unknown', ip: '192.168.10.105' }, { mac: '00:D8:61:D8:47:3B', knownHost: false, vendor: 'Unknown', ip: '192.168.10.106' }, { mac: 'B4:2E:99:87:2A:C6', knownHost: false, vendor: 'Unknown', ip: '192.168.10.107' }, { mac: 'B4:2E:99:41:8E:97', knownHost: false, vendor: 'Unknown', ip: '192.168.10.108' }, { mac: '00:1E:42:23:96:66', knownHost: false, vendor: 'Teltonika', ip: '192.168.10.187' }, { mac: '54:BF:64:54:55:C9', knownHost: false, vendor: 'Unknown', ip: '192.168.10.220' }, { mac: '00:1E:42:2B:92:3B', knownHost: false, vendor: 'Teltonika', ip: '192.168.10.254' }], subnet: '192.168.10.62/24' }, { myHost: { mac: '00:1E:42:27:10:10', vendor: 'OpenWrt', ip: '192.168.1.1' }, discription: 'LAN', hosts: [{ mac: '18:D6:C7:04:8D:4F', knownHost: false, vendor: 'Tp-link Technologies', ip: '192.168.1.131' }], subnet: '192.168.1.0/24' }],
      neededHeight: 2000
    }
  },
  methods: {
    get_subnets () {
      this.$rpc.call('nethosts', 'main', {}).then((r) => {
        this.subnets = JSON.parse(r.hosts)
        console.log(JSON.stringify(this.subnets))
      })
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
    DesktopSvg
  }
}
</script>

<style scoped>
  .box{
    width: 100px;
    height: 100px;
    z-index: 9;
    display: flex;
    background: #9b9696;
  }
  .box > *{
    width: 100px;
    height: 100px;
  }
  .host{
    position: absolute;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-flow: column;
    border-radius: 10px;
    padding: 25px;
    z-index:2;
    transform: translate(-110px, -75px);
    cursor: default;
    width: 220px
  }
  .host:hover{
    width: 400px;
    transform: translate(-200px, -75px);
    z-index: 10;
    background: rgba(150,150,150);
    box-shadow: 3px 7px 3px 7px rgba(100,100,100,0.5);
  }
  .lines{
    position: absolute;
    top: 0px;
    left: 0px;
  }
  .info{
    display: flex;
    align-items: center;
    justify-content: center;
    flex-flow: column;
  }
  .info.aditional-info{
    display:none;
  }
  .host:hover .info.aditional-info{
    display:flex;
  }
</style>
