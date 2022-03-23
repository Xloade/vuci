<template>
  <div>
    <vpn-table ref="table" @edit="(name) => $refs.formModal.showModal(name)"/>
    <edit-form-modal ref="formModal" @edited="$refs.table.getVPNs()"/>
  </div>
</template>

<script>
import EditFormModal from './EditFormModal.vue'
import VpnTable from './VpnTable.vue'
export default {
  components: {
    EditFormModal,
    VpnTable
  }
}
</script>

<style scoped>

</style>
