<template>
  <div>
    <vpn-table ref="table" @edit="(name) => $refs.formModal.showModal(name)"/>
    <add-form @created="$refs.table.getVPNs()"/>
    <edit-form-modal ref="formModal" @edited="$refs.table.getVPNs()"/>
  </div>
</template>

<script>
import EditFormModal from './EditFormModal.vue'
import AddForm from './AddForm.vue'
import VpnTable from './VpnTable.vue'
export default {
  components: {
    EditFormModal,
    AddForm,
    VpnTable
  }
}
</script>

<style scoped>

</style>
