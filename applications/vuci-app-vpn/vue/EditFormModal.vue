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
              {{$t("addForm.skey")}}
            </a-select-option>
            <a-select-option value="tls">
              {{$t("addForm.tls")}}
            </a-select-option>
          </a-select>
      </a-form-model-item>
      <div class="server" v-if="form.type == 'server'">
        <div class="tls" v-if="form.auth == 'tls'">
          <a-form-model-item :label="$t('addForm.serverIp')" prop="name">
            <a-input v-model="form.server.ip" style="width: 250px"/>
          </a-form-model-item>
          <a-form-model-item :label="$t('addForm.serverNetmask')" prop="name">
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
        <div class="tls" v-if="form.auth == 'tls'">
            <a-form-model-item :label="$t('editForm.certserver')">
              <a-upload
                :file-list="form.cert" @change="(e) => handleChange(form.cert, e)" accept=".pem" action="/upload" :data="{path: '/etc/vuci-uploads/cbid.openvpn.'+form.name+'.'+form.type+'.cert.pem'}">
                <a-button size="small" type="primary" icon="upload">{{ $t('editForm.Select File') }}</a-button>
              </a-upload>
            </a-form-model-item>
            <a-form-model-item :label="$t('editForm.keyserver')">
              <a-upload
                :file-list="form.key" @change="(e) => handleChange(form.key, e)" accept=".pem" action="/upload" :data="{path: '/etc/vuci-uploads/cbid.openvpn.'+form.name+'.'+form.type+'.key.pem'}">
                <a-button size="small" type="primary" icon="upload">{{ $t('editForm.Select File') }}</a-button>
              </a-upload>
            </a-form-model-item>
        </div>
        <div class="skey" v-else-if="form.auth == 'skey'">
        </div>
      </div>
      <div class="tls" v-if="form.auth == 'tls'">
        <a-form-model-item :label="$t('editForm.ca')">
          <a-upload
            :file-list="form.ca" @change="(e) => handleChange(form.ca, e)" accept=".pem" action="/upload" :data="{path: '/etc/vuci-uploads/cbid.openvpn.'+form.name+'.ca.cert.pem'}">
            <a-button size="small" type="primary" icon="upload">{{ $t('editForm.Select File') }}</a-button>
          </a-upload>
        </a-form-model-item>
        <a-form-model-item :label="$t('editForm.certserver')">
            <a-upload
              :file-list="form.cert" @change="(e) => handleChange(form.cert, e)" accept=".pem" action="/upload" :data="{path: '/etc/vuci-uploads/cbid.openvpn.'+form.name+'.'+form.type+'.cert.pem'}">
              <a-button size="small" type="primary" icon="upload">{{ $t('editForm.Select File') }}</a-button>
            </a-upload>
          </a-form-model-item>
          <a-form-model-item :label="$t('editForm.keyserver')">
            <a-upload
              :file-list="form.key" @change="(e) => handleChange(form.key, e)" accept=".pem" action="/upload" :data="{path: '/etc/vuci-uploads/cbid.openvpn.'+form.name+'.'+form.type+'.key.pem'}">
              <a-button size="small" type="primary" icon="upload">{{ $t('editForm.Select File') }}</a-button>
            </a-upload>
          </a-form-model-item>
      </div>
      <div class="skey" v-else-if="form.auth == 'skey'">

        </div>
      </a-form-model>
    </a-modal>
  </div>
</template>
<script>
export default {
  data () {
    return {
      visible: false,
      labelCol: { span: 6 },
      wrapperCol: { span: 12 },
      rules: {
      },
      form: {
        isEnabled: true,
        auth: '',
        name: '',
        route: {
          ip: '192.168.145.0',
          mask: '255.255.255.0'
        },
        server: {
          ip: '',
          mask: ''
        },
        ca: [],
        cert: [],
        key: [],
        dh: [],
        type: ''
      }
    }
  },
  methods: {
    showModal (name) {
      this.form.name = name
      this.getVPN()
      this.visible = true
    },
    handleCreate (e) {
      this.$refs.form.validate(valid => {
        if (valid) {
          this.$rpc.call('vpn', 'edit', { form: this.form }).then((r) => {
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
        form.server.ip = vpn.server_ip
        form.server.mask = vpn.server_netmask
        form.ca = [{ uid: '-1', name: vpn.ca, status: 'done' }]
        form.cert = [{ uid: '-1', name: vpn.cert, status: 'done' }]
        form.key = [{ uid: '-1', name: vpn.key, status: 'done' }]
        form.dh = [{ uid: '-1', name: vpn.dh, status: 'done' }]
        console.log(form)
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
