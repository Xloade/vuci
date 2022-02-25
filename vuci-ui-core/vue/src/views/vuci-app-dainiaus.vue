<template>
  <div class="example">
    <div class="viewport" ref="viewport" @mousedown="mouseDownHandler" @wheel.prevent="mouseWheelHandler">
      <div class="elementArea" ref="viewport" :style="{transform: `scale(${zoom})`}">
        <div class="host" v-for="(host, index) in hosts[0].hosts['unknown hosts']" :key="host.ip" :style="getPositionStyle(index, hosts[0].hosts['unknown hosts'].length, 0, 180)">
          <div class="box" @mouseover="addHoverToParent" @mouseleave="removeHoverFromParent"/>
          <div class="info">
            <div>Mac: {{host.mac}}</div>
            <div>Ip: {{host.ip}}</div>
          </div>
        </div>
        <svg v-for="(host, index) in hosts[0].hosts['unknown hosts']" :key="host.ip + '1'">
          <line x1="1600" y1="450" :x2="getPosition(index, hosts[0].hosts['unknown hosts'].length, 0, 180).left" :y2="getPosition(index, hosts[0].hosts['unknown hosts'].length, 0, 180).top" stroke="black" />
        </svg>
      </div>
    </div>
    <a-button type="primary" @click="get_hosts">{{$t("Examples")}}</a-button>
  </div>
</template>

<script>
export default {
  data () {
    return {
      zoom: 1,
      pos: { top: 0, left: 0, x: 0, y: 0 },
      hosts: [{ discription: 'My home LAN', hosts: { 'unknown hosts': [{ mac: '4C:CC:6A:5F:85:5D', ip: '192.168.10.1' }, { mac: '00:1E:42:4C:08:13', ip: '192.168.10.2' }, { mac: '4C:CC:6A:5F:8A:1C', ip: '192.168.10.7' }, { mac: '4C:CC:6A:5F:85:8D', ip: '192.168.10.13' }, { mac: '00:1E:42:48:34:FD', ip: '192.168.10.14' }, { mac: '4C:CC:6A:5F:85:5C', ip: '192.168.10.16' }, { mac: '00:1E:42:23:E0:67', ip: '192.168.10.17' }, { mac: '4C:CC:6A:5F:85:65', ip: '192.168.10.25' }, { mac: '00:1E:42:4A:4C:28', ip: '192.168.10.26' }, { mac: '4C:CC:6A:5F:85:5B', ip: '192.168.10.29' }, { mac: '1C:1B:0D:E0:15:14', ip: '192.168.10.31' }, { mac: '1C:1B:0D:E0:10:67', ip: '192.168.10.34' }, { mac: '1C:1B:0D:E0:67:78', ip: '192.168.10.37' }, { mac: '00:1E:42:32:AC:2B', ip: '192.168.10.45' }, { mac: '1C:1B:0D:E0:67:7A', ip: '192.168.10.46' }, { mac: '00:1E:42:29:1B:7F', ip: '192.168.10.50' }, { mac: '1C:1B:0D:E0:67:EF', ip: '192.168.10.55' }, { mac: '1C:1B:0D:9F:F8:0B', ip: '192.168.10.61' }, { mac: '18:C0:4D:3F:24:BD', ip: '192.168.10.101' }, { mac: 'B4:2E:99:14:62:2D', ip: '192.168.10.102' }, { mac: '38:2C:4A:64:2D:E5', ip: '192.168.10.103' }, { mac: 'E0:D5:5E:26:F4:C2', ip: '192.168.10.104' }, { mac: 'D4:5D:64:52:76:A8', ip: '192.168.10.105' }, { mac: '00:D8:61:D8:47:3B', ip: '192.168.10.106' }, { mac: 'B4:2E:99:87:2A:C6', ip: '192.168.10.107' }, { mac: 'B4:2E:99:41:8E:97', ip: '192.168.10.108' }, { mac: '00:1E:42:23:96:66', ip: '192.168.10.187' }, { mac: '00:1E:42:2B:92:3B', ip: '192.168.10.254' }, { mac: '00:1E:42:27:10:11', ip: '192.168.10.62' }], 'known hosts': {} }, subnet: '192.168.10.62/24' }]
    }
  },
  methods: {
    get_hosts () {
      this.$rpc.call('nethosts', 'main', {}).then((r) => {
        this.hosts = JSON.parse(r.hosts)
      })
    },
    addHoverToParent (e) {
      e.target.parentElement.classList.add('hostHovered')
    },
    removeHoverFromParent (e) {
      e.target.parentElement.classList.remove('hostHovered')
    },
    getPosition (index, itemCount, startAngle, finishAngle) {
      // const itemAngle = ((finishAngle - startAngle) / (itemCount - 1)) * index
      // const lenghtFromCenter = 700
      // const center = { top: 450, left: 1600 }
      // const top = center.top + Math.sin(this.degToRad(itemAngle)) * lenghtFromCenter
      // const left = center.left + Math.cos(this.degToRad(itemAngle)) * lenghtFromCenter * 2
      const lenghtFromCenter = 300
      const center = { top: 450, left: 1600 }
      const itemPlace = 3000 / (itemCount - 1) * index
      const top = center.top - lenghtFromCenter
      const left = center.left - 1500 + itemPlace
      return {
        top: top,
        left: left
      }
    },
    getPositionStyle (index, itemCount, startAngle, finishAngle) {
      const position = this.getPosition(index, itemCount, startAngle, finishAngle)
      return {
        top: `${position.top}px`,
        left: `${position.left}px`
      }
    },
    degToRad (degrees) {
      var pi = Math.PI
      return degrees * (pi / 180)
    },
    mouseWheelHandler (e) {
      if (event.deltaY < 0) {
        // Zoom in
        this.zoom *= event.deltaY * -0.01
      } else {
        // Zoom out
        this.zoom /= event.deltaY * 0.01
      }
    },
    mouseDownHandler (e) {
      this.$refs.viewport.style.cursor = 'grabbing'
      this.$refs.viewport.style.userSelect = 'none'

      this.pos = {
        left: this.$refs.viewport.scrollLeft,
        top: this.$refs.viewport.scrollTop,
        // Get the current mouse position
        x: e.clientX,
        y: e.clientY
      }
      document.addEventListener('mousemove', this.mouseMoveHandler)
      document.addEventListener('mouseup', this.mouseUpHandler)
    },
    mouseMoveHandler (e) {
      const dx = e.clientX - this.pos.x
      const dy = e.clientY - this.pos.y

      // Scroll the element
      this.$refs.viewport.scrollTop = this.pos.top - dy
      this.$refs.viewport.scrollLeft = this.pos.left - dx
    },
    mouseUpHandler () {
      this.$refs.viewport.style.cursor = 'grab'
      this.$refs.viewport.style.removeProperty('user-select')

      document.removeEventListener('mousemove', this.mouseMoveHandler)
      document.removeEventListener('mouseup', this.mouseUpHandler)
    }
  }
}
</script>

<style scoped>
  .viewport{
    width: 100%;
    height: 700px;
    background: #9b9696;
    overflow: auto;
    cursor: grab;
    position: relative;
  }
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
    border-radius: 25px;
    padding: 25px;
    z-index:2;
    transform: translate(-100px, -75px);
  }
  .hostHovered{
    z-index: 10;
    background: rgba(150,150,150);
    box-shadow: 3px 7px 3px 7px rgba(100,100,100,0.5);;
  }
  .elementArea{
    width: 200%;
    height: 200%;
    z-index:1;
  }
  svg{
    width: 100%;
    height: 100%;
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
  .info{
    pointer-events: none;
  }
</style>
