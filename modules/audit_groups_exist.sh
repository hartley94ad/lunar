# audit_groups_exist
#
# Over time, system administration errors and changes can lead to groups being
# defined in /etc/passwd but not in /etc/group.
# Groups defined in the /etc/passwd file but not in the /etc/group file pose a
# threat to system security since group permissions are not properly managed.
#
# Refer to Section(s) 9.2.11 Page(s) 170-1 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.2.11 Page(s) 196-7 CIS Red Hat Enterprise Linux 5 Benchmark v2.1.0
# Refer to Section(s) 9.2.11 Page(s) 173-4 CIS Red Hat Enterprise Linux 6 Benchmark v1.2.0
# Refer to Section(s) 6.2.15 Page(s) 282   CIS Red Hat Enterprise Linux 7 Benchmark v2.1.0
# Refer to Section(s) 13.11  Page(s) 161-2 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 9.11   Page(s) 80    CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 9.11   Page(s) 124-5 CIS Solaris 10 Benchmark v1.1.0
# Refer to Section(s) 6.2.15 Page(s) 269   CIS Amazon Linux Benchmark v2.1.0
#.

audit_groups_exist () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    funct_verbose_message "User Groups"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Groups in passwd file exist in group file"
    fi
    check_file="/etc/group"
    group_fail=0
    total=`expr $total + 1`
    if [ "$audit_mode" != 2 ]; then
      for group_id in `getent passwd |cut -f4 -d ":"`; do
        group_exists=`cat $check_file |grep -v "^#" |cut -f3 -d":" |grep "^$group_id$" |wc -l |sed "s/ //g"`
        if [ "$group_exists" = 0 ]; then
          group_fail=1
          if [ "$audit_mode" = 1 ];then
            insecure=`expr $insecure + 1`
            echo "Warning:   Group $group_id does not exist in group file [$insecure Warnings]"
          fi
        fi
      done
      if [ "$group_fail" != 1 ]; then
        if [ "$audit_mode" = 1 ];then
          secure=`expr $secure + 1`
          echo "Secure:    No non existant group issues [$secure Passes]"
        fi
      fi
    fi
  fi
}
