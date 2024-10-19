<template>
  <div class="home">
      <h3 id="heading">Supply Chain with Data Integrity</h3>
        <el-row :gutter="50">
          <el-col :span="10">
            <el-card shadow="hover">
              <a href="createCert"><img class="unitIcon" src="../assets/imgs/cert.png" /></a>
              <br>
              <el-link :underline="false" href="createCert"><p class="nameTag">Validator</p></el-link>
            </el-card>
          </el-col>
          <el-col :span="10">
            <el-card shadow="hover">
              <a href="productLaunch"><img class="unitIcon" src="../assets/imgs/prodLaunch.png" /></a>
              <br>
              <el-link :underline="false" href="productLaunch"><p class="nameTag">Product launch</p></el-link>
            </el-card>
          </el-col>
        </el-row>
  </div>
</template>

<script>

export default {
  data () {
    return {
    }
  },
  created () {

  },
  methods: {

  }
}
</script>
<style scoped>
.home {
  background-color: #ffffff;
  border-radius: 4px;
  margin: 0.1% auto;
  width: 75%;
  padding: 1rem 1.5rem;
}
#heading {
  margin-top: -4%;
  margin-bottom: 6%;
}
.unitIcon{
  height: 7rem;
  border-radius: 50%;
  width: 7em;
}
.unitIcon:hover{
    transform: scale(1.1); /* Negative value rotates and decreases size.*/
}
.nameTag{
  color: rgb(133, 112, 143);
  font-size: 1.5rem;
  font-family: sans-serif;
}
</style>
