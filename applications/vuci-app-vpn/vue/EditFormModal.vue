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
        <a-form-model-item :label="$t('editForm.isEnabled')">
          <a-switch v-model="form.isEnabled"/>
        </a-form-model-item>
        <a-form-model-item :label="$t('editForm.auth')" prop="type">
          <a-select v-model="form.auth" style="width: 250px">
            <a-select-option value="skey">
              {{$t("editForm.skey")}}
            </a-select-option>
            <a-select-option value="tls">
              {{$t("editForm.tls")}}
            </a-select-option>
          </a-select>
        </a-form-model-item>
      <div class="notTlsServer" v-if="!(form.type == 'server' && form.auth == 'tls')">
        <a-form-model-item :label="$t('editForm.network.ip')">
          <a-input v-model="form.network.ip" style="width: 250px"/>
        </a-form-model-item>
        <a-form-model-item :label="$t('editForm.network.mask')">
          <a-input v-model="form.network.mask" style="width: 250px"/>
        </a-form-model-item>
      </div>
      <div class="server" v-if="form.type == 'server'">
        <div class="tls" v-if="form.auth == 'tls'">
          <a-form-model-item :label="$t('editForm.server.ip')" prop="name">
            <a-input v-model="form.server.ip" style="width: 250px"/>
          </a-form-model-item>
          <a-form-model-item :label="$t('editForm.server.mask')" prop="name">
            <a-input v-model="form.server.mask" style="width: 250px"/>
          </a-form-model-item>
          <a-form-model-item :label="$t('editForm.dh')">
            <a-upload
              :file-list="form.dh" @change="(e) => handleChange(form.dh, e)" accept=".pem" action="/upload" :data="{path: '/etc/vuci-uploads/cbid.openvpn.'+form.name+'.dh.pem'}">
              <a-button size="small" type="primary" icon="upload">{{ $t('editForm.Select File') }}</a-button>
            </a-upload>
          </a-form-model-item>
        </div>
        <div class="skey" v-else-if="form.auth == 'skey'">

        </div>
      </div>
      <div class="client" v-else-if="form.type == 'client'">
        <a-form-model-item :label="$t('editForm.remote')">
          <a-input v-model="form.remote" style="width: 250px"/>
        </a-form-model-item>
        <div class="tls" v-if="form.auth == 'tls'">
        </div>
        <div class="skey" v-else-if="form.auth == 'skey'">
        </div>
      </div>
      <div class="OnlyTls" v-if="form.auth == 'tls'">
        <a-form-model-item :label="$t('editForm.ca')">
          <a-upload
            :file-list="form.ca" @change="(e) => handleChange(form.ca, e)" accept=".pem" action="/upload" :data="{path: '/etc/vuci-uploads/cbid.openvpn.'+form.name+'.ca.cert.pem'}">
            <a-button size="small" type="primary" icon="upload">{{ $t('editForm.Select File') }}</a-button>
          </a-upload>
        </a-form-model-item>
        <a-form-model-item :label="$t('editForm.cert')">
            <a-upload
              :file-list="form.cert" @change="(e) => handleChange(form.cert, e)" accept=".pem" action="/upload" :data="{path: '/etc/vuci-uploads/cbid.openvpn.'+form.name+'.'+form.type+'.cert.pem'}">
              <a-button size="small" type="primary" icon="upload">{{ $t('editForm.Select File') }}</a-button>
            </a-upload>
        </a-form-model-item>
        <a-form-model-item :label="$t('editForm.key')">
          <a-upload
            :file-list="form.key" @change="(e) => handleChange(form.key, e)" accept=".pem" action="/upload" :data="{path: '/etc/vuci-uploads/cbid.openvpn.'+form.name+'.'+form.type+'.key.pem'}">
            <a-button size="small" type="primary" icon="upload">{{ $t('editForm.Select File') }}</a-button>
          </a-upload>
        </a-form-model-item>
      </div>
      <div class="OnlySkey" v-else-if="form.auth == 'skey'">
        <a-form-model-item :label="$t('editForm.localIp')">
          <a-input v-model="form.localIp" style="width: 250px"/>
        </a-form-model-item>
        <a-form-model-item :label="$t('editForm.remoteIp')">
          <a-input v-model="form.remoteIp" style="width: 250px"/>
        </a-form-model-item>
        <a-form-model-item :label="$t('editForm.secret')">
          <a-upload
            :file-list="form.secret" @change="(e) => handleChange(form.ca, e)" accept=".key" action="/upload" :data="{path: '/etc/vuci-uploads/cbid.openvpn.'+form.name+'.secretstatic.key'}">
            <a-button size="small" type="primary" icon="upload">{{ $t('editForm.Select File') }}</a-button>
          </a-upload>
        </a-form-model-item>
      </div>
      </a-form-model>
    </a-modal>
  </div>
</template>
<script>
const formStart = {
  isEnabled: true,
  auth: '',
  name: '',
  server: {
    ip: '',
    mask: ''
  },
  ca: [],
  cert: [],
  key: [],
  dh: [],
  type: '',
  remote: '',
  network: {
    ip: '',
    mask: ''
  },
  localIp: '',
  remoteIp: '',
  secret: []
}

export default {
  data () {
    return {
      visible: false,
      labelCol: { span: 6 },
      wrapperCol: { span: 12 },
      rules: {
      },
      form: {},
      formStart
    }
  },
  methods: {
    showModal (name) {
      // deep copy of formStart
      this.form = JSON.parse(JSON.stringify(formStart))
      this.visible = true
      this.form.name = name
      this.getVPN()
    },
    handleCreate (e) {
      this.$refs.form.validate(valid => {
        if (valid) {
          this.$rpc.call('vpn', 'edit', { form: this.form })
            .then(this.$uci.apply())
            .then(this.$system.initRestart('openvpn'))
            .then((r) => {
              this.$refs.form.resetFields()
              this.$emit('edited')
              this.visible = false
            })
        }
      })
    },
    handleCancel (e) {
      this.visible = false
    },
    getVPN () {
      this.$rpc.call('vpn', 'getVpn', { name: this.form.name }).then((r) => {
        const vpn = r.vpn
        const form = this.form
        form.type = vpn.type
        form.isEnabled = vpn.enable
        form.auth = vpn._auth
        if (!(vpn.type === 'server' && vpn._auth === 'tls')) {
          form.network.ip = vpn.network_ip
          form.network.mask = vpn.network_mask
        }
        if (vpn.type === 'server') {

        } else if (form.type === 'client') {
          form.remote = vpn.remote
        }
        if (vpn._auth === 'tls') {
          form.ca = vpn.ca !== '' ? [{ uid: '-1', name: vpn.ca, status: 'done' }] : []
          form.cert = vpn.cert !== '' ? [{ uid: '-1', name: vpn.cert, status: 'done' }] : []
          form.key = vpn.key !== '' ? [{ uid: '-1', name: vpn.key, status: 'done' }] : []
          if (vpn.type === 'server') {
            form.dh = vpn.dh !== '' ? [{ uid: '-1', name: vpn.dh, status: 'done' }] : []
            form.server.ip = vpn.server_ip
            form.server.mask = vpn.server_netmask
          } else if (form.type === 'client') {

          }
        } else if (vpn._auth === 'skey') {
          form.secret = vpn.secret !== '' ? [{ uid: '-1', name: vpn.secret, status: 'done' }] : []
          form.localIp = vpn.local_ip
          form.remoteIp = vpn.remote_ip
        }
      })
    },
    handleChange (usedFileList, info) {
      const fileList = [...info.fileList]
      // use only first file
      usedFileList.splice(0, usedFileList.length)
      if (fileList.length > 0) {
        usedFileList.push(fileList[fileList.length - 1])
      }
    }
  }
}
</script>
