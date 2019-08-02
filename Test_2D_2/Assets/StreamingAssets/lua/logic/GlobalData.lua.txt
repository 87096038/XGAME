local GlobalData={}

function GlobalData:Init()

    ---这里是从服务器获取数据后，计算出的各个数值

    --------------角色相关----------------
    self.characterSpeed = 5


    ----------------枪------------------
    self.lightSpeed = 10
    self.heavySpeed = 10
    self.shellSpeed = 5
    --激光宽度
    self.laserWidth = 2



    ----------------敌人----------------
    self.enemyBaseSpeed = 5


end

GlobalData:Init()
return GlobalData