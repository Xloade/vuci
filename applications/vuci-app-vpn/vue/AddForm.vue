<template>
  <div>
    <a-form-model
      :rules="rules" :model="form" layout="inline" ref="form"
    >
      <a-form-model-item :label="$t('addForm.name')" prop="name">
        <a-input v-model="form.name" style="width: 250px"/>
      </a-form-model-item>
      <a-form-model-item :label="$t('addForm.type')" prop="type">
        <a-select v-model="form.type" style="width: 250px">
          <a-select-option value="server">
            {{$t("addForm.server")}}
          </a-select-option>
          <a-select-option value="client">
            {{$t("addForm.client")}}
          </a-select-option>
        </a-select>
      </a-form-model-item>
      <a-form-item>
      <a-button type="primary" @click="add">
        Add VPN
      </a-button>
    </a-form-item>
    </a-form-model>
  </div>
</template>

<script>
export default {
  data () {
    return {
      form: {
        name: '',
        type: ''
      },
      rules: {

      }
    }
  },
  methods: {
    add () {
      this.$refs.form.validate(valid => {
        if (valid) {
          this.$rpc.call('vpn', 'addVpn', { form: this.form })
            .then(this.$uci.apply())
            .then(this.$system.initRestart('openvpn'))
            .then((r) => {
              this.$refs.form.resetFields()
              this.$emit('created')
            })
        }
      })
    }
  }
}
</script>

<style scoped>

</style>
