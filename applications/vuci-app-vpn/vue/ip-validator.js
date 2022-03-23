// from vuci-ui-core/vue/src/plugins/vuci-validator.js
function parseIPv4 (str) {
  if ((typeof (str) !== 'string' && !(str instanceof String)) ||
    !str.match(/^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/)) { return undefined }

  const num = []
  const parts = str.split(/\./)

  for (let i = 0; i < parts.length; i++) {
    const n = parseInt(parts[i])
    if (isNaN(n) || n > 255) { return undefined }

    num.push(n)
  }

  return num
}

const pattern = {
  trailingZeros: new RegExp('(0*)$')
}

function getnumOfTraillingZerosFromMask (mask) {
  const maskArray = parseIPv4(mask)
  const bitArrays = maskArray.map((element, index) => {
    const rawBase2 = element.toString(2)
    const neededZerosTo8bit = '0'.repeat(8 - rawBase2.length)
    return neededZerosTo8bit + rawBase2
  })
  const bitArray = bitArrays.join('')
  const numOfTrailingZeros = pattern.trailingZeros.exec(bitArray)[1].length
  return numOfTrailingZeros
}

export default {
  isEqualMask (ip, mask) {
    try {
      return getnumOfTraillingZerosFromMask(ip) >= getnumOfTraillingZerosFromMask(mask)
    } catch (error) {
      return true
    }
  }
}
