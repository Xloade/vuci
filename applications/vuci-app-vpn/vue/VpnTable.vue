<template>
  <a-table :columns="VPNColumns" :data-source="VPNs" :rowKey="(a) => a._name">
    <template slot="status" slot-scope="text">
      {{text == "Enabled" ? $t('table.status.enabled') : $t('table.status.disabled')}}
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
</template>
<script>
export default {
  data () {
    return {
      VPNs: [],
      VPNColumns: [
        {
          dataIndex: '_name',
          title: this.$t('name')
        },
        {
          dataIndex: 'status',
          title: this.$t('status'),
          scopedSlots: { customRender: 'status' }
        },
        {
          dataIndex: 'operation',
          scopedSlots: { customRender: 'operation' }
        }
      ]
    }
  },
  methods: {
    getVPNs () {
      this.$rpc.call('vpn', 'getVpns', {}).then((r) => {
        this.VPNs = r.vpns
      })
    },
    disable (name) {
      this.$rpc.call('vpn', 'disable', { name: name }).then((r) => {
        this.getVPNs()
      })
    },
    enable (name) {
      this.$rpc.call('vpn', 'enable', { name: name }).then((r) => {
        this.getVPNs()
      })
    },
    deleteVpn (name) {
      this.$rpc.call('vpn', 'delete', { name: name }).then((r) => {
        this.getVPNs()
      })
    }

  },
  mounted () {
    this.getVPNs()
  }
}
</script>

<style scoped>
  .operations{
    display: flex;
    gap: 6px;
  }
</style>
