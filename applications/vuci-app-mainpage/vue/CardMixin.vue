<script>
export default {
  data () {
    return {
      info: {},
      extraInfo: {},
      name: 'No name',
      title: 'No title'
    }
  },
  computed: {
    combinedInfo () {
      return { ...this.info, ...this.extraInfo }
    }
  }
}
</script>
