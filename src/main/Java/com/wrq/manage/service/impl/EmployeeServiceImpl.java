package com.wrq.manage.service.impl;

import com.wrq.manage.bean.Employee;
import com.wrq.manage.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by 王乾 on 2018/1/9.
 */
@Service("iEmployeeService")
public class EmployeeServiceImpl {

    @Autowired
    private EmployeeMapper employeeMapper;

    public List<Employee> getAll(){
        return  employeeMapper.selectByExampleWithDept(null);
    }

}