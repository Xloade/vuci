<template>
  <div>
    <div class="toggles" :style="{width: `${visible ? 300: 0}px`}">
      <div class="toggle-inner">
        <h3>Show/hide information cards</h3>
        <a-form-model class="form" :label-col="{ span: 12 }" :wrapper-col="{ span: 12 }">
          <div v-for="card in cards" :key="card.name" >
            <a-form-model-item :label="$t(card.name)" v-if="card.name !== 'wan6Card'">
              <a-switch  v-model="card.info.show" @change="syncFiltered"/>
            </a-form-model-item>
          </div>
        </a-form-model>
      </div>
    </div>
    <a-button class="openModalBtn" type="primary" @click="toggleVisibility" :style="{right: `${visible ? 300: 0}px`}">
      <settings-svg class="settings-svg"/>
    </a-button>
    <a-row :gutter="[12,12]" type="flex">
      <draggable class="drag" @change="saveOrder" :list="filteredCards" @start="drag=true" @end="drag=false" :animation="200" ghost-class="ghost-card">
        <a-col class="outer-card" :span="6" v-for="card in filteredCards" :key="card.name">
          <component :is="card.name"/>
        </a-col>
      </draggable>
    </a-row>
  </div>
</template>

<script>
import SystemCard from './SystemCard.vue'
import SystemLogCard from './SystemLogCard.vue'
import NetworkLogCard from './NetworkLogCard.vue'
import LanCard from './LANCard.vue'
import WanCard from './WANCard.vue'
import Wan6Card from './WAN6Card.vue'
import AccessCard from './AccessCard.vue'
import draggable from 'vuedraggable'
import SettingsSvg from './settingsSvg.vue'
export default {
  data () {
    return {
      cards: [],
      filteredCards: [],
      visible: false
    }
  },
  methods: {
    syncFiltered () {
      this.cards.find(e => e.name === 'wan6Card').info.show = this.cards.find(e => e.name === 'wanCard').info.show
      this.filteredCards = this.filteredCards.map((e, i) => {
        e.info.order = i
      })
      this.filteredCards = this.cards.filter((e) => e.info.show).sort((a, b) => { return a.info.order - b.info.order })
    },
    saveShow () {
      this.$rpc.call('mainpage', 'SaveShow', { cards: this.cards })
    },
    saveOrder () {
      this.filteredCards = this.filteredCards.map((e, i) => {
        e.info.order = i
        return e
      })
      this.$rpc.call('mainpage', 'SaveOrder', { cards: this.filteredCards })
    },
    get () {
      this.$rpc.call('mainpage', 'Get', {})
        .then(r => {
          this.cards = r.cards.map(e => {
            return {
              name: e['.name'],
              info: {
                order: Number(e.order),
                show: e.show === '1'
              }
            }
          })
            .sort((a, b) => {
              return a.info.order - b.info.order
            })
          this.syncFiltered()
        })
    },
    toggleVisibility () {
      if (this.visible) this.saveShow()
      this.visible = !this.visible
    }
  },
  created () {
    this.get()
  },
  components: {
    SystemCard,
    SystemLogCard,
    NetworkLogCard,
    LanCard,
    WanCard,
    Wan6Card,
    AccessCard,
    draggable,
    SettingsSvg
  }
}
</script>

<style>
.outer-card{
  border: 1px solid #c2c2c200;
}
.ghost-card {
  opacity: 0.5;
  background: #F7FAFC;
  border: 1px solid #4299e1;
}
.openModalBtn{
  height: 60px;
  width: 35px;
  border-radius: 5px 0px 0px 5px;
  padding: 5px;
  position: absolute;
  top: 120px;
  z-index: 10000;
}
.drag{
  width: 100%;
}
.settings-svg{
  fill: white
}
.toggles{
  position: absolute;
  top: 100px;
  right: 0px;
  z-index: 10000;
  transition: all 0.3s cubic-bezier(0.645, 0.045, 0.355, 1);
  border: 1px solid #c2c2c2;
  background: white;
  border-radius: 5px 0px 0px 5px;
  overflow: hidden;
}
.toggle-inner{
  padding: 12px;
  width: 300px !important;
}
.form{
  width: 100%;
}
.toggle-inner h3{
  margin: 20px;
}
</style>
