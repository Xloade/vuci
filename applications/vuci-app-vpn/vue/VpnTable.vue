<template>
  <div class="">
    <a-table :columns="VPNColumns" :data-source="VPNs" :rowKey="(a) => a._name">
      <template slot="name" slot-scope="name, record">
        {{name}}_{{record.type}}
      </template>
      <template slot="status" slot-scope="text">
        {{$t('table.status.'+text)}}
      </template>
      <template slot="operation" slot-scope="text, record, index">
        <div class="operations">
          <a-button type="primary"
            @click="$emit('edit', VPNs[index]._name)"
          >
            {{$t('table.button.edit')}}
          </a-button>
          <a-button
            v-if="VPNs[index].enable == '1'"
            @click="disable(VPNs[index]._name)"
          >
            {{$t('table.button.disable')}}
          </a-button>
          <a-button v-else
            @click="enable(VPNs[index]._name)"
          >
            {{$t('table.button.enable')}}
          </a-button>
          <a-button
            type="danger"
            @click="deleteVpn(VPNs[index]._name)"
          >
            {{$t('table.button.delete')}}
          </a-button>
        </div>
      </template>
    </a-table>
    <add-form @created="getVPNs()" :currentVPNs="VPNs"/>
  </div>
</template>
<script>
import AddForm from './AddForm.vue'
export default {
  data () {
    return {
      VPNs: [],
      VPNColumns: [
        {
          dataIndex: '_name',
          title: this.$t('name'),
          scopedSlots: { customRender: 'name' },
          width: '33%'
        },
        {
          dataIndex: 'status',
          title: this.$t('status'),
          scopedSlots: { customRender: 'status' },
          width: '33%'
        },
        {
          dataIndex: 'operation',
          scopedSlots: { customRender: 'operation' },
          width: '33%'
        }
      ],
      refresh: null
    }
  },
  methods: {
    getVPNs () {
      this.$rpc.call('vpn', 'getVpns', {}).then((r) => {
        this.VPNs = r.vpns
      })
    },
    disable (name) {
      this.$rpc.call('vpn', 'disable', { name: name })
        .then(this.$uci.apply())
        .then(this.$system.initRestart('openvpn'))
        .then((r) => {
          this.getVPNs()
        })
    },
    enable (name) {
      this.$rpc.call('vpn', 'enable', { name: name })
        .then(this.$uci.apply())
        .then(this.$system.initRestart('openvpn'))
        .then((r) => {
          this.getVPNs()
        })
    },
    deleteVpn (name) {
      if (confirm(this.$t('table.confirm delete'))) {
        this.$rpc.call('vpn', 'delete', { name: name })
          .then(this.$uci.apply())
          .then(this.$system.initRestart('openvpn'))
          .then((r) => {
            this.getVPNs()
          })
      }
    }

  },
  mounted () {
    this.getVPNs()
    this.refresh = setInterval(this.getVPNs, 5000)
  },
  beforeDestroy () {
    clearInterval(this.refresh)
  },
  components: {
    AddForm
  }
}
</script>

<style scoped>
  .operations{
    display: flex;
    gap: 6px;
  }
</style>
