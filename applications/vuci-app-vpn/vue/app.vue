<template>
  <div>
    <vpn-table ref="table"/>
    <add-form @created="$refs.table.getVPNs()"/>
    <edit-form-modal @edit="(name) => $refs.formModal.showModal(name)" ref="formModal"/>
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
