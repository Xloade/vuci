<template>
  <div class="example">
    <ZoomDragViewport :showInner="subnets.length>0" :areaWidth="neededWidth" :areaHeight="neededHeight" excludeClassFromDrag="host">
        <div class="subnet" v-for="(subnet, subnetIndex) in subnets" :key="subnet.discription">
          <div @mousedown.stop class="host" v-for="(host, index) in subnet.hosts" :key="host.ip" :style="getPositionStyle(index, getHostNumFromSubNet(subnet), getOffsetY(subnetIndex))">
            <div class="box"/>
            <div class="info">
              <div>Mac: {{host.mac}}</div>
              <div>Ip: {{host.ip}}</div>
            </div>
            <div class="info aditional-info">
              <div>Mac: {{host.mac}}</div>
              <div>Ip: {{host.ip}}</div>
            </div>
          </div>
          <svg :style="[{width:`${neededWidth}px`},{height:`${neededHeight}px`}]">
            <line v-for="(host, index) in subnet.hosts" :key="host.ip + '1'"
              :x1="neededWidth/2" :y1="neededHeight/2"
              :x2="getPosition(index, getHostNumFromSubNet(subnet), getOffsetY(subnetIndex)).left"
              :y2="getPosition(index, getHostNumFromSubNet(subnet), getOffsetY(subnetIndex)).top" stroke="black" />
          </svg>
        </div>
      </ZoomDragViewport>
    <a-button type="primary" @click="get_subnets">{{$t("Examples")}}</a-button>
  </div>
</template>

<script>
import ZoomDragViewport from './ZoomDragViewport'
export default {
  data () {
    return {
      // subnets: [],
      subnets: [{ discription: 'WAN', hosts: [{ mac: '4C:CC:6A:5F:85:5D', knownHost: false, ip: '192.168.10.1' }, { mac: '00:1E:42:4C:08:13', knownHost: false, ip: '192.168.10.2' }, { mac: '4C:CC:6A:5F:8A:1C', knownHost: false, ip: '192.168.10.7' }, { mac: '00:1E:42:32:70:6A', knownHost: false, ip: '192.168.10.8' }, { mac: '4C:CC:6A:5F:85:8D', knownHost: false, ip: '192.168.10.13' }, { mac: '00:1E:42:48:34:FD', knownHost: false, ip: '192.168.10.14' }, { mac: '4C:CC:6A:5F:85:5C', knownHost: false, ip: '192.168.10.16' }, { mac: '00:1E:42:23:E0:67', knownHost: false, ip: '192.168.10.17' }, { mac: '00:1E:42:4A:4C:28', knownHost: false, ip: '192.168.10.26' }, { mac: '1C:1B:0D:E0:15:14', knownHost: false, ip: '192.168.10.31' }, { mac: '1C:1B:0D:E0:10:67', knownHost: false, ip: '192.168.10.34' }, { mac: '1C:1B:0D:E0:67:78', knownHost: false, ip: '192.168.10.37' }, { mac: '00:1E:42:32:AC:2B', knownHost: false, ip: '192.168.10.45' }, { mac: '1C:1B:0D:E0:67:7A', knownHost: false, ip: '192.168.10.46' }, { mac: '1C:1B:0D:9F:F8:0B', knownHost: false, ip: '192.168.10.61' }, { mac: '18:C0:4D:3F:24:BD', knownHost: false, ip: '192.168.10.101' }, { mac: 'B4:2E:99:14:62:2D', knownHost: false, ip: '192.168.10.102' }, { mac: '38:2C:4A:64:2D:E5', knownHost: false, ip: '192.168.10.103' }, { mac: 'D4:5D:64:52:76:A8', knownHost: false, ip: '192.168.10.105' }, { mac: '00:D8:61:D8:47:3B', knownHost: false, ip: '192.168.10.106' }, { mac: 'B4:2E:99:87:2A:C6', knownHost: false, ip: '192.168.10.107' }, { mac: 'B4:2E:99:41:8E:97', knownHost: false, ip: '192.168.10.108' }, { mac: '00:1E:42:23:96:66', knownHost: false, ip: '192.168.10.187' }, { mac: '00:1E:42:2B:92:3B', knownHost: false, ip: '192.168.10.254' }, { mac: '00:1E:42:27:10:11', knownHost: false, ip: '192.168.10.62' }], subnet: '192.168.10.62/24' }, { discription: 'LAN', hosts: [{ mac: '18:D6:C7:04:8D:4F', knownHost: false, ip: '192.168.1.131' }, { mac: '00:1E:42:27:10:10', knownHost: false, ip: '192.168.1.1' }, { mac: '00:1E:42:27:10:10', knownHost: false, ip: '1972.1684.1.1' }, { mac: '00:1E:42:27:10:10', knownHost: false, ip: '192.1568.1.1' }, { mac: '00:1E:42:27:10:10', knownHost: false, ip: '1952.1658.1.1' }, { mac: '00:1E:42:27:10:10', knownHost: false, ip: '19542.1658.1.1' }, { mac: '00:1E:42:27:10:10', knownHost: false, ip: '192.1568.15.1' }, { mac: '00:1E:42:27:10:10', knownHost: false, ip: '192.1658.1.1' }, { mac: '00:1E:42:27:10:10', knownHost: false, ip: '192.1685.1.1' }, { mac: '00:1E:42:27:10:10', knownHost: false, ip: '1992.1685.1.1' }, { mac: '00:1E:42:27:10:10', knownHost: false, ip: '1692.1568.1.1' }, { mac: '00:1E:42:27:10:10', knownHost: false, ip: '192.1658.1.141' }, { mac: '00:1E:42:27:10:10', knownHost: false, ip: '192.168.51.1' }, { mac: '00:1E:42:27:10:10', knownHost: false, ip: '1925.168.1.1' }], subnet: '192.168.1.0/24' }],
      neededHeight: 2000
    }
  },
  methods: {
    get_subnets () {
      this.$rpc.call('nethosts', 'main', {}).then((r) => {
        this.subnets = JSON.parse(r.hosts)
      })
    },
    getPosition (index, itemCount, offsetY) {
      // const itemAngle = ((finishAngle - startAngle) / (itemCount - 1)) * index
      // const lengthFromCenter = 700
      // const center = { top: 450, left: 1600 }
      // const top = center.top + Math.sin(this.degToRad(itemAngle)) * lengthFromCenter
      // const left = center.left + Math.cos(this.degToRad(itemAngle)) * lengthFromCenter * 2
      const groupWidth = this.widthFromItemCount(itemCount)
      const center = { top: this.neededHeight / 2, left: this.neededWidth / 2 }
      const startLeft = (this.neededWidth / 2 - groupWidth / 2) + 100
      const itemPlace = ((groupWidth - 200) / (itemCount - 1) * index) + startLeft
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
    ZoomDragViewport
  }
}
</script>

<style scoped>
  .box{
    width: 100px;
    height: 100px;
    background: red;
    z-index: 9;
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
    transform: translate(-100px, -75px);
    cursor: default;
  }
  .host:hover{
    width: 400px;
    transform: translate(-200px, -75px);
    z-index: 10;
    background: rgba(150,150,150);
    box-shadow: 3px 7px 3px 7px rgba(100,100,100,0.5);
  }
  svg{
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
