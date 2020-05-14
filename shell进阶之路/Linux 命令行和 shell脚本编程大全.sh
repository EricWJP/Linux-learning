查看 shell 
cat /etc/shells

jobs -l 查看后台作业
sleep 10 休眠10s

printenv 查看全局环境变量
  $_ 
env   查看全局环境变量
区别
printenv HOME
env $HOME

set命令会显示出全局变量、局部变量以 及用户定义变量,它还会按照字母顺序对结果进行排序
env和printenv命令同set命 令的区别在于前两个命令不会对变量排序，也不会输出局部变量和用户定义变量

所有的环境变量名均使用大写字母，这是bash shell的标准惯例。如果是你自己创建的局部变量或是shell脚本，请使用小写字母。变量名区分大小写。在涉及用户定义的局部变量 时坚持使用小写字母，这能够避免重新定义系统环境变量可能带来的灾难。

创建全局变量： 退出重新打开就没有了
  先创建一个局部变量，再导出到全局环境中
  my_variable="I am Global now"
  export my_variable
子shell 无法改变父shell 的全局环境变量
但可以覆盖

unset my_variable 删除全局变量,不能删除局部变量



当想要直接运行某个目录下的shell脚本
PATH=$PATH:.
把当前目录加入到了 $PATH 中




协程：
  同时做两件事：
    后台生成一个子shell
    并在这个子shell中执行命令
  coproc My_Job { sleep 10; } 不可丢分号
  coproc sleep 10

type 命令
  了解某个命令是不是内建命令
  type -a 命令
which 命令
whereis 命令

alias -p 查看所有的alias 命令




shell
登录shell会从5个不同的启动文件里 读取命令:
/etc/profile
$HOME/.bash_profile
$HOME/.bashrc
$HOME/.bash_login 
$HOME/.profile

/etc/profile文件是系统上默认的bash shell的主启动文件
系统上的每个用户登录时都会执行 这个启动文件

大多数Linux发行版只用这四个启动文件中的一到两个:
$HOME/.bash_profile 
$HOME/.bashrc
$HOME/.bash_login 
$HOME/.profile


shell会按照按照下列顺序，运行第一个被找到的文件，余下的则被忽略:
  $HOME/.bash_profile 
  $HOME/.bash_login
  $HOME/.profile
注意，这个列表中并没有$HOME/.bashrc文件。这是因为该文件通常通过其他文件运行的。


bash是作为交互式shell启动的，它就不会访问/etc/profile文件，只会检查用户HOME目录 中的.bashrc文件

数组 
环境变量数组的索引值都是从零开始
mytest=(one two three four five)
echo $mytest    输出 one
echo $mytest[@]    输出 one[@]

使用索引 必须使用{}
echo  ${mytest[@]}
echo  ${mytest[1]}  输出 one

使用 @ 、 * 符号可以获取数组中的所有元素
echo ${array[@]}
echo ${array[*]}
# 取得数组指定元素的长度
echo ${#array[2]}
# 取得数组元素的个数
echo ${#array[@]}
# 取得数组元素的个数
echo ${#array[*]}
# 取得数组单个元素的长度（取最大）
echo ${#array[n]}



数组定义：
  declare -a names
  names[0]=tom
  names[1]=jack

  #定义的同时直接赋值
  declare -a names=(tom jack)
  #增加元素
  names[2]=sue

  #使用()直接数组
  days1=(one two three four five)
  #或者在()中声明下标，默认从0开始
  days2=([0]=’one’ [1]=’two’ [2]=’three’ [3]=’four’)
  #下标可以不连续
  days3=([0]=’one’ [2]=’three’)

  从文件读取数组
  days=(`cat days.txt`)

删除数组或数组元素，使用delete函数
delete array                 #删除整个数组
delete array[item]           #删除某个数组元素（item）

连接
用()将多个数组连接在一起，()中各个数组用空格隔开。
days=(one two three four)
names=(tom jack)
days=(${days[@]} ${names[@]})



字符串
引用
  双引号
    str="test"
    echo "quote \"$str\""
    使用双引号的优点：
      双引号里可以有变量
      双引号里可以出现转义字符
  单引号
    str='this is a string'
    使用单引号有所限制：
      在echo命令下，单引号里的任何字符都会原样输出，单引号字符串中的变量是无效的
      单引号字串中不能出现单独一个的单引号（对单引号使用转义符后也不行），但可成对出现，作为字符串拼接使用。
  无引号
    str=this is a string
    str=this
    不使用引号只适合引用单个单词变量时使用，空格之后的字符无法识别。

字符串操作
  拼接字符串
    your_name="Jerry"
    # 使用双引号拼接
    greeting1="hello, "$your_name" !\r"
    greeting2="hello, ${your_name} !"
    echo -e $greeting1$greeting2
    # 使用单引号拼接
    greeting3='hello, '$your_name' !\r'
    greeting4='hello, ${your_name} !'
    echo -e $greeting3$greeting4
    输出
    
      hello, Jerry !
      hello, Jerry !
      hello, Jerry !
      hello, ${your_name} !
  获取字符串长度
    string="abcdefg"
    echo ${#string} 
    #输出为7
  提取字符串
    string="I am learning Shell!"
    echo ${string:1:5} # 输出 am l
    echo ${string:3}   # 输出 m learning Shell!
  反引号使用
    如果需要调用命令的输出，或把命令的输出赋予变量，则命令必须使用反引号包含，这条命令才会执行
    反引号的作用和$(命令)是一样的，但是反引号非常容易和单引号搞混，所以推荐大家使用 $(命令) 的方式引用命令的输出。
    echo `date`
    #输出为：Tue Jun 25 01:43:27 UTC 2019
    #作用与命令  echo $(date)  相同
  查找子字符串
    string="I am learning Shell!"
    echo `expr index "$string" Sh`
    echo $(expr index "$string" Sh)
    #输出为 15
    查找字符 S 的位置(哪个字母先出现就计算哪个)

创建用户
查看所用Linux系统中的这些默认值
  useradd -D
删除用户
  userdel 用户名
  userdel -r 用户名 同时删除用户home目录的文件
修改用户
  -c修改备注字段，-e修改过期日期，-g修改默认的登录组
  usermode
    -l修改用户账户的登录名。
    -L锁定账户，使用户无法登录。 
    -p修改账户的密码。
    -U解除锁定，使用户能够登录
修改用户密码
  passwd 用户名  改自己的密码
  passwd -e 用户名  强制用户下次登陆修改自己的密码

从系统的标准输入读入用户的名称和口令，并利用这些信息来更新系统上已存在的用户的口令
chpasswd < users.txt


chsh、chfn和chage工具专门用来修改特定的账户信息。chsh命令用来快速修改默认的用户登录shell。使用时必须用shell的全路径名作为参数，不能只用shell名
chsh -s /bin/csh 用户名
如果在使用chfn命令时没有参数，它会向你询问要将哪些适合的内容加进备注字段。
chage命令用来帮助管理用户账户的有效期。你需要对每个值设置多个参数
  -d -E -I -m -W
  设置上次修改密码到现在的天数
  设置密码过期的日期
  设置密码过期到锁定账户的天数
  设置修改密码之间最少要多少天
  设置密码过期前多久开始出现提醒信息

finger命令可以非常方便地查看Linux系统上的用户信息
  finger username
出于安全性考虑，很多Linux系统管理员会在系统上禁用finger命令，不少Linux发行版 甚至都没有默认安装该命令。



创建新组
groupadd shared
给组添加用户
usermod -G shared rich

groupmod命令可以修改已有组的 GID(加-g选项)或组名(加-n选项)。
groupmod -n sharing shared
修改组名时，GID和组成员不会变，只有组名改变。由于所有的安全权限都是基于GID的， 你可以随意改变组名而不会影响文件的安全性。

chown 用户 文件/文件夹
chown 用户:组名 文件/文件夹
  -R 递归变更
chgrp 组名 文件/文件夹  更改组名
  -R 递归变更

umask
umask -S
文件 666 - umask
目录 777 - umask

chmod 改变权限

Linux还为每个文件和目录存储了3个额外的信息位。
设置用户ID(SUID):当文件被用户使用时，程序会以文件属主的权限运行。
  SUID 仅可用在 binary program 上， 不能够用在 shell script 上面!
  SUID 对于目录也是无效的
  SUID 权限仅对二进制程序(binary program)有效;
􏰀  执行者对于该程序需要具有 x 的可执行权限;
􏰀  本权限仅在执行该程序的过程中有效 (run-time);
􏰀  执行者将具有该程序拥有者 (owner) 的权限。

设置组ID(SGID):对文件来说，程序会以文件属组的权限运行;对目录来说，目录中
创建的新文件会以目录的默认属组作为默认属组。
  SGID 对二进制程序有用;
􏰀  程序执行者对于该程序来说，需具备 x 的权限;
􏰀  执行者在执行的过程中将会获得该程序群组的支持!
事实上 SGID 也能够用在目录上，这也是非常常见的一种用途! 
  用户若对于此目录具有r与x的权限时，该用户能够进入此目录;
􏰀  用户在此目录下的有效群组(effective group)将会变成该目录的群组;
􏰀  用途:若用户在此目录下具有 w 的权限(可以新建档案),则使用者所建立的新档案，该新档案的
群组与此目录的群组相同。

粘着位:进程结束后文件还驻留(粘着)在内存中。
  Sticky Bit, SBIT 目前只针对目录有效
  当用户对于此目录具有 w, x 权限，亦即具有写入的权限时;
􏰀  当用户在该目录下建立档案或目录时，仅有自己与 root 才有权力删除该档案
  drwxrwxrwt

  4为SUID 􏰀 2为SGID 􏰀 1为SBIT

  chmod 4755 filename



PMS的不足之处在于目前还没有统一的标准工具。不管你用的是哪个Linux发行版，本书到
目前为止所讨论的bash shell命令都能工作，但对于软件包管理可就不一定了。 PMS工具及相关命令在不同的Linux发行版上有很大的不同。Linux中广泛使用的两种主要的PMS基础工具是dpkg和rpm

基于Debian的发行版(如Ubuntu和Linux Mint)使用的是dpkg命令
基于Red Hat的发行版(如Fedora、openSUSE及Mandriva)使用的是rpm命令，该命令是其PMS 的底层基础。类似于dpkg命令，rmp命令能够列出已安装包、安装新包和删除已有软件。

dpkg命令是基于Debian系PMS工具的核心。包含在这个PMS中的其他工具有: apt-get   apt-cache   
和基于Debian的发行版类似，基于Red Hat的系统也有几种不同的可用前端工具。常见的有 以下3种
  yum:在Red Hat和Fedora中使用
  urpm:在Mandriva中使用
  zypper:在openSUSE中使用


yum list installed
yum擅长找出某个特定软件包的详细信息。它能给出关于包的非常详尽的描述，另外你还可 以通过一条简单的命令查看包是否已安装
yum list xterm
yum list installed xterm
如果需要找出系统上的某个特定文件属于哪个软件包
  yum provides file_name
yum install package_name
手动下载rpm安装文件并用yum安装，这叫作本地安装。基本的命令是:
  yum localinstall package_name.rpm
但如果发现某个特定 软件包需要更新，输入如下命令:
  yum update package_name

只删除软件包而保留配置文件和数据文件
  yum remove package_name

要删除软件和它所有的文件，就用erase选项:
yum erase package_name

损坏的包依赖关系:
  yum clean all
  然后 yum命令的update选项

显示了所有包的库依赖关系以及什么软件可以提供这些库依赖关系
  yum deplist package_name
更新时跳过 依赖关系损坏的包
  yum update --skip-broken

软件仓库  /etc/yum.repos.d
  yum repolist

源码安装
下载文件并解压缩
  tar -zxvf sysstat-11.1.1.tar.gz
安装检查
  ./configure
构建二进制文件
  make   当前目录下生成二进制代码
  sudo make install   安装到Linux系统中常用的位置上
  或者使用 root用户身份登陆 执行 make install



命令输出给变量：
 反引号 ``   `date`
 $()        $(ls)

重定向
 输出
  command > outputfile
  date > file
  双大于号(>>)来追加数据
    date >> file
 输入
  command < inputfile
  wc < test6
 内联输入重定向  "
  command << marker
  marker
  "

管道
  command1 ｜ command2

整数运算
  运算符两侧必须有空格
 expr 5 * 2
 使用方括号
  运算符两侧不必有空格
  echo $[1+(5*2)]

 expr 1.2 \< 5.2 返回 1
 expr 1.2 \> 5.2 返回 0
 bc  使用scale 可执行浮点运算 
  scale=4 保留小数点4个
  echo "scale=4; 3.44/5" | bc

查看退出状态码
  echo $?
  正常是 0
  ctrl + c  130
  不可用参数/不存在文件文件夹 2
  命令未找到 127
  权限拒绝   126



结构化命令
if语句
  如果该命令的退出状态码是0 (该命令成功运行)，位于then部分的命令就会被执行。
  如果该命令的退出状态码是其他值，then 部分的命令就不会被执行
if command
then
  commands
fi
if command; then
  commands
fi

if command; then
  commands
elif command2; then
  commands
else
  commands
fi

if-then语句是否能测试命令退出状态码之外的条件
test命令提供了在if-then语句中测试不同条件的途径
如果test命令中列出的条件成立， test命令就会退出并返回退出状态码0
这样if-then语句就与其他编程语言中的if-then语句以类似的方式工作了。如果条件不成立，test命令就会退出并返回非零的退出状态码，这使得 if-then语句不会再被执行。

如果不写test命令的condition部分，它会以非零的退出状态码退出

if test "Full"
then
   echo "The $my_variable expression returns a True"
else
   echo "The $my_variable expression returns a False"
fi

另一种条件测试方法
if [ condition ]
then
  commands
fi
支持三类条件
  数值比较
  字符串比较
  文件比较

数值比较 整数
  n1 -eq n2
  n1 -ge n2
    -gt
    -le
    -lt
    -ne
字符串比较
  str1 = str2
  str1 != str2
  str1 \< str2  需要转义
  str1 \> str2  需要转义
 -n和-z可以检查一个变量是否含有数据
  -n str1   检查str1的长度是否非0
  -z str1   检查str1的长度是否为0

  大于号和小于号必须转义，否则shell会把它们当作重定向符号，把字符串值当作文件名
  大于和小于顺序和sort命令所采用的不同
    大写字母被认为是 小于 小写字母的

比较测试中使用的是标准的ASCII顺序，根据每个字符的ASCII数值来决定排序结果
sort 命令使用的是系统的本地化语言设置中定义的排序顺序
对于英语，本地化设置指定了在排序顺序中小写字母出现在大写字母前。

如果你对数值使用了数学运算符 号，shell会将它们当成字符串值，可能无法得到正确的结果。

空的和未初始化的变量会对shell脚本测试造成灾难性的影响。如果不是很确定一个变量的
内容，最好在将其用于数值或字符串比较之前先通过-n或-z来测试一下变量是否含有值。

文件比较
  -d file   检查file是否存在并是一个目录 
  -e file   检查file是否存在
  -f file   检查file是否存在并是一个文件 
  -r file   检查file是否存在并可读 
  -s file   检查file是否存在 并非空 
  -w file   检查file是否存在并可写 
  -x file   检查file是否存在并可执行 
  -O file   检查file是否存在并属当前用户所有 
  -G file   检查file是否存在并且默认组与当前用户相同 
  file1 -nt file2   检查file1是否比file2新 
  file1 -ot file2   检查file1是否比file2旧

复合条件测试
  两种布尔逻辑运算符可用
    [ condition1 ] && [ condition2 ]
    [ condition1 ] || [ condition2 ]

高级特性
  用于数学表达式的双括号 
  用于高级字符串处理功能的双方括号

 双括号  (( expression ))  仅仅整数运算
  expression可以是任意的数学赋值或比较表达式 "
  val++   后增
  val--   后减
  ++val   先增
  --val   先减
  !       逻辑求反
  ~       位求反
  **      乘方
  <<      左移
  >>      右移
  &       位与
  |       位或
  &&      逻辑与
  ||      逻辑或
  "

if 双括号条件 空格不是必须的
val=10
if (($val**2>15)); then
  echo "first if"
fi

 双方括号 [[ expression ]]
  双方括号里的expression使用了test命令中采用的标准字符串比较。
  但它提供了test命令未提供的另一个特性——模式匹配(pattern matching)
  空格必须有 [[ 和 ]] 运算符 都必须有空格
    [[ $user == r* ]];
      == 把右边的字符串视为一个正则表达式
    [[ rich ]]
    [[ $rich ]]


case 命令   注意每一个case最后必须双分号 ;;
  case variable in
  pattern1 | pattern2) commands1;; 
  pattern3) commands2;;
  *) default commands;;
  esac
case $USER in
rich | barbara)
  echo "Welcome, $USER"
  echo "Please enjoy your visit";;
testing)
  echo "Special testing account";;
jessica)
  echo "Do not forget to log off when you're done";;
*)
  echo "Sorry, you are not allowed here";;
esac


FOR 命令
  for var in list
  do
    commands
  done
  for var in list; do
    commands
  done

for test in rich eric "Colorado"; do
  echo The next state is $test
done
echo "The last state we visited was $test" test=Connecticut
echo "Wait, now we're visiting $test"

使用转义字符(反斜线)来将单引号转义;
使用双引号来定义用到单引号的值
使用双引号来定义用到的包含空格的值
for循环假定每个值都是用空格分割的, 即使多行，每一行也是以空格分割的
for test in I don\'t know if "this'll" work in "New York"
do
    echo "word:$test"
done

字符串连接 即使 $list未初始化
list=$list" Connecticut"

特殊的环境变量IFS，叫作内部字段分隔符
默认情况下，bash shell会将下列字 符当作字段分隔符
  空格 制表符 换行符    "
IFS=$'\n'     换行
IFS=$' \t\n'  空格 制表符 换行
IFS=:         冒号
IFS=$'\n':;"  换行、冒号、分号、双引号

在处理代码量较大的脚本时，可能在一个地方需要修改IFS的值，然后忽略这次修改，
在脚本的其他地方继续沿用IFS的默认值。
一个可参考的安全实践是在改变IFS之前保存原 来的IFS值，之后再恢复它。
IFS.OLD=$IFS 
IFS=$'\n' 
<在代码中使用新的IFS值> 
IFS=$IFS.OLD


通配符读取目录
for命令来自动遍历目录中的文件。进行此操作时，必须在文件名或路径名中使用通配符。
它会强制shell使用文件扩展匹配。文件扩展匹配是生成匹配指定通配符的文件名或路径名的过程。

for file in /home/rich/test/*
do
  if [ -d "$file" ] 
  then
    echo "$file is a directory" 
  elif [ -f "$file" ]
  then
    echo "$file is a file"
  fi
done

if [ -d "$file" ]
  目录名和文件名中包含空格当然是合法的。
  要适应这种情况，应该将$file变量用双引号圈起来

多个目录通配符合并后遍历
for file in do /home/rich/.b* /home/rich/badtest
done

可以将任意多的通配符放进列表中

支持C语言风格的for命令
for (( i=1; i <= 10; i++ ))
do
    echo "The next number is $i"
done

C语言风格的for命令也允许为迭代使用多个变量。循环会单独处理每个变量，你可以为每
个变量定义不同的迭代过程。
尽管可以使用多个变量，但你只能在for循环中定义一种条件。
for (( a=1, b=10; a <= 10; a++, b-- )) 
do
  echo "$a - $b" 
  expr $a - $b    #输出结果差
done




WHILE   test command 与if 是一样的
while test command
do
  other commands
done

使用多个测试命令
while命令允许你在while语句行定义多个测试命令。只有最后一个测试命令的退出状态码会被用来决定什么时候结束循环。
如果你不够小心，可能会导致一些有意思的结果。下面的例子将说明这一点。

while echo $var1
        [ $var1 -ge 0 ]
do
  echo "This is inside the loop" 
  var1=$[ $var1 - 1 ]
done

UNTIL
until命令和while命令工作的方式完全相反
只有测试命令的退出状态码不为0，bash shell才会执行循环中列出的命令。 一旦测试命令返回了退出状态码0，循环就结束了。
until test commands 
do
  other commands
done

until echo $var1
        [ $var1 -eq 0 ]
do
  echo Inside the loop: $var1 
  var1=$[ $var1 - 25 ]
done

循环可以嵌套
控制循环
  break命令   终止所在最内层的循环
  break 层数  终止循环层数(从所在最内层开始计算)
  continue命令 中止当前次循环，进行下一次循环
  continue 层数 在某层循环中止，进行该层循环的下一次循环


创建多个用户账户
必须作为root用户才能运行这个脚本，因为useradd命令需要root权限
read命令读取文件中的各行
read命令会自动读取.csv文本文件的下一行内容，所以不需要专门再写一个循环来处理。
当read命令返回FALSE时(也就是读取完整个文件时)，while命令就会退出。妙极了!
把每一行用 ',' 分割成两个值
input="users.csv"
while IFS=',' read -r userid name 
do
  echo "adding $userid"
  useradd -c "$name" -m $userid 
done < "$input"



参数 $0 第一个路径 
    $1 第一个参数
    $2 第二个参数
    $# 参数数量
    ${!#} 最后一个参数


$*和$@变量可以用来轻松访问所有的参数。这两个变量都能够在单个变量中存储所有的命令行参数。
$*变量会将命令行上提供的所有参数当作 一个单词 保存。这个单词包含了命令行中出现的每 一个参数值。
  基本上$*变量会将这些参数视为一个整体，而不是多个个体。
$@变量会将命令行上提供的所有参数当作同一字符串中的多个独立的单词。这样 你就能够遍历所有的参数值，得到每个参数。这通常通过for命令完成。

# testing $* and $@
#
echo
count=1
#
for param in "$*"
do
   echo "\$* Parameter #$count = $param"
   count=$[ $count + 1 ]
done
#
echo
count=1
#
for param in "$@"
do
   echo "\$@ Parameter #$count = $param"
   count=$[ $count + 1 ]
done

输出：
  $ ./test12.sh rich barbara katie jessica
  $* Parameter #1 = rich barbara katie jessica
  $@ Parameter #1 = rich
  $@ Parameter #2 = barbara
  $@ Parameter #3 = katie
  $@ Parameter #4 = jessica


打印1-20数字
for i in {1..20}; do 
  echo i
done
打印a-z字母
for i in {'a'..'z'}; do 
  echo i
done


cat {file1,file2,file3} > combined_file
# 把file1, file2, file3连接在一起, 并且重定向到combined_file中.
cp file22.{txt,backup}
# 拷贝"file22.txt"到"file22.backup"中


()会开启一个新的子shell，{}不会开启一个新的子shell

(())常用于算术运算比较所有的变量(加不加$无所谓)都是数值; 
[[]]常用于字符串的比较.

$()返回括号中命令执行的结果

$(())返回的结果是括号中表达式值

${}参数替换与扩展



ls log_0{0..9}.error  查看log_01.error--log_09.error
ls log_{01,02}.error  查看log_01.error--log_02.error
touch 20180622_{0..10}.log   创建多个日志文件


top -b 手动回车刷新
top -n 1 只显示一次





