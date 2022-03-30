<template>
  <div>
    <a-row :gutter="[12,12]" type="flex">
      <draggable @change="save" v-model="cards" @start="drag=true" @end="drag=false" :animation="200" ghost-class="ghost-card">
        <a-col class="card" :span="8" v-for="card in cards" :key="card.name">
          <component :is="card.name"/>
        </a-col>
      </draggable>
    </a-row>
  </div>
</template>

<script>
import SystemCard from './SystemCard.vue'
import LoggingCard from './LoggingCard.vue'
import draggable from 'vuedraggable'
export default {
  data () {
    return {
      cards: [
        {
          name: 'system-card',
          info: null
        },
        {
          name: 'logging-card',
          info: null
        },
        {
          name: 'logging-card',
          info: null
        },
        {
          name: 'logging-card',
          info: null
        },
        {
          name: 'logging-card',
          info: null
        }
      ]
    }
  },
  methods: {
    save () {
      
    }
  },
  components: {
    SystemCard,
    LoggingCard,
    draggable
  }
}
</script>

<style>
.card{
  border: 1px solid #4299e100;
}
.ghost-card {
  opacity: 0.5;
  background: #F7FAFC;
  border: 1px solid #4299e1;
}
</style>
