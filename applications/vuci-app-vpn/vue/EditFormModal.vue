<template>
  <div>
    <a-modal
      title="Edit VPN"
      :visible="visible"
      okText="Create"
      :cancelButtonProps="{props: {type:'danger'}}"
      @ok="handleCreate"
      @cancel="handleCancel"
    >
      <a-form-model ref="form" :rules="rules" :model="form" :label-col="labelCol" :wrapper-col="wrapperCol">
        <a-form-model-item :label="$t('editForm.isActive')">
          <a-switch v-model="form.isActive"/>
        </a-form-model-item>
      </a-form-model>
    </a-modal>
  </div>
</template>
<script>
export default {
  props: ['type'],
  data () {
    return {
      visible: false,
      labelCol: { span: 6 },
      wrapperCol: { span: 12 },
      rules: {
      },
      form: {
        isActive: true
      }
    }
  },
  methods: {
    showModal () {
      this.visible = true
    },
    handleCreate (e) {

    },
    handleCancel (e) {
      this.visible = false
    }
  }
}
</script>
