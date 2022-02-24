<template>
  <div v-if="isFirstLogin" class="popup-back">
    <a-card title="Change password">
      <a-form-model style="width: 400px" ref="form" :model="form" :rules="rules">
        <a-form-model-item :label="$t('wizard.Password')" prop="password">
          <a-input-password v-model="form.password"/>
        </a-form-model-item>
        <a-form-model-item :label="$t('wizard.Confirmation')" prop="confirm">
          <a-input-password v-model="form.confirm"/>
        </a-form-model-item>
      </a-form-model>
      <a-button type="primary" @click="submit">{{ $t('wizard.Submit') }}</a-button>
    </a-card>
  </div>
</template>

<script>
import { rpc } from '@/plugins/rpc'
export default {
  name: 'ForceChangePassword',
  data () {
    const validatePass = (rule, value, callback) => {
      if (value === '') {
        callback(new Error(this.$t('wizard.Please enter your password')))
      } else {
        if (this.form.confirm !== '') { this.$refs.form.validateField('confirm') }
        callback()
      }
    }

    const validatorConfirm = (rule, value, callback) => {
      if (value === '') {
        callback(new Error(this.$t('wizard.Please enter your password again')))
      } else if (value !== this.form.password) {
        callback(new Error(this.$t('wizard.Inconsistent input password twice!')))
      } else {
        callback()
      }
    }

    return {
      isFirstLogin: false,
      form: {
        password: '',
        confirm: ''
      },
      rules: {
        password: [{ validator: validatePass }],
        confirm: [{ validator: validatorConfirm }]
      }
    }
  },
  methods: {
    async firstLogin () {
      rpc.call('ui', 'first_login').then(r => {
        this.isFirstLogin = r.first
      })
    },
    submit () {
      this.$refs.form.validate(valid => {
        if (!valid) return
        this.$rpc.call('ui', 'first_set', {
          username: 'admin',
          password: this.form.password
        }).then(() => {
          this.$router.push('/login')
        })
      })
    }
  },
  mounted () {
    this.firstLogin()
  }
}
</script>

<style scoped>
  .popup-back{
    position: absolute;
    top: 0px;
    left: 0px;
    height: 100vh;
    width: 100vw;
    background: rgba(100, 100, 100, 0.33);
    display: flex;
    align-items: center;
    justify-content: center;
  }
</style>
