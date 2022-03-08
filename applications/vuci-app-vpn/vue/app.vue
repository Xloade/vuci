<template>
  <div>
    <add-edit-form-modal ref="formModal"/>
    <a-button type="primary" @click="$refs.formModal.showModal()">
      Create
    </a-button>
  </div>
</template>

<script>
import AddEditFormModal from './EditFormModal.vue'
export default {
  components: {
    AddEditFormModal
  }
}
</script>

<style scoped>

</style>
