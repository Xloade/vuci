<template>
    <div class="host">
        <div class="logo">
            <slot name="logo">
              <template v-if="host">
                    <RouterSvg v-if="host.vendor=='Teltonika'"/>
                    <DesktopSvg v-else/>
              </template>
            </slot>
        </div>
        <div class="info">
            <slot name="info">
              <template v-if="host">
                <div v-if="host.knownHost">Name: {{host.discription}}</div>
                <div>Ip: {{host.ip}}</div>
                <div>Mac: {{host.mac}}</div>
                <div class="portStatus" v-if="host.ports">
                    Ports:
                    <div class="portStatusDot" :style="{background: anyOpenPorts(host.ports)?'green':'red'}"></div>
                </div>
              </template>
            </slot>
        </div>
        <div class="info aditional-info">
            <slot name="info-aditional">
              <template v-if="host">
                <div>Vendor: {{host.vendor}}</div>
                <a-table rowKey="port" class="ports" v-if="host.ports" :data-source="host.ports" :columns="pingTableCols" >
                    <span slot="status" slot-scope="status">
                    <a-tag
                        :color="status === 'open' ? 'green' : status === 'closed' ? 'red' : 'orange'"
                    >
                        {{ status.toUpperCase() }}
                    </a-tag>
                    </span>
                </a-table>
              </template>
            </slot>
        </div>
    </div>
</template>

<script>
import RouterSvg from './RouterSvg'
import DesktopSvg from './DesktopSvg'
export default {
  props: ['host'],
  data () {
    return {
      pingTableCols: [
        {
          title: 'Port',
          dataIndex: 'port'
        },
        {
          title: 'Used for',
          dataIndex: 'service'
        },
        {
          title: 'Status',
          dataIndex: 'status',
          scopedSlots: { customRender: 'status' }
        }
      ]
    }
  },
  components: {
    DesktopSvg,
    RouterSvg
  },
  methods: {
    anyOpenPorts (ports) {
      let res = false
      ports.forEach(element => {
        if (element.status === 'open') res = true
      })
      return res
    }
  }
}
</script>

<style scoped>
    .logo{
    width: 100px;
    height: 100px;
    z-index: 9;
    display: flex;
    background: #9b9696;
  }
  .logo > *{
    width: 100px;
    height: 100px;
  }
  .knownHost .logo svg{
    fill: green;
  }
  .host:hover{
    width: 400px;
    transform: translate(-200px, -75px);
    z-index: 10;
    background: rgba(200,200,200);
    box-shadow: 3px 7px 3px 7px rgba(100,100,100,0.5);
  }
  .host:hover .logo{
    background: rgba(200,200,200);
  }
  .info, .info *{
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
  .ports{
    background: white;
    padding: 3px;
    border-radius: 3px;
    margin: 5px 0px
  }
  .portStatus{
    display: inline;
  }
  .portStatusDot{
    width: 12px;
    height: 12px;
    border-radius: 6px;
    display: inline-block;
  }
  .host{
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
</style>
