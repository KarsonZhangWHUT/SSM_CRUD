package com.karson.crud.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.karson.crud.bean.Employee;
import com.karson.crud.bean.Msg;
import com.karson.crud.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 处理员工的eCRUD请求
 *
 * @author karson
 */
@Controller
public class EmployeeController {
    @Autowired
    EmployeeService employeeService;

    /**
     * 单个批量二合一
     * 批量删除：1-2-2
     * 单个删除：1
     *
     * @param
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{id}", method = RequestMethod.DELETE)
    public Msg deleteEmpById(@PathVariable("id") String ids) {
        if (ids.contains("-")) {
            String[] str_ids = ids.split("-");
            List<Integer> del_ids = new ArrayList<>();
            for (String str_id : str_ids) {
                del_ids.add(Integer.parseInt(str_id));
            }
            employeeService.deleteBatch(del_ids);
        } else {
            int id = Integer.parseInt(ids);
            employeeService.deleteEmp(id);
        }
        return Msg.success();
    }

    /**
     * 如果直接发送ajax=PUT形式的请求封装数据
     * <p>
     * 问题：
     * 请求体中有数据，但是Employee对象封装不上
     * <p>
     * 原因：Tomcat：
     * 1.将请求体中的数据，封装成为一个map。
     * 2.request.getParameter("empName")就会从这个map中取值。
     * 3.SpringMVC封装POJO对象的时候，会把POJO中每个属性的值，request.getParameter("email");
     * <p>
     * AJAX发送PUT请求引发的血案：
     * PUT请求：请求体重的数据，request.getParameter("empName")拿不到
     * Tomcat一看是PUT，不会封装请求体中的数据为map，只有POST形式的请求才会封装map
     * 员工更新方法
     *
     * @param employee
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{empId}", method = RequestMethod.PUT)
    public Msg saveEmp(Employee employee, HttpServletRequest request) {
        System.out.println(employee);
        employeeService.updateEmp(employee);
        return Msg.success();
    }


    /**
     * 根据ID查询员工
     *
     * @return
     */
    @RequestMapping(value = "/emp/{id}", method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("id") Integer id) {
        Employee employee = employeeService.getEmp(id);
        return Msg.success().add("emp", employee);
    }


    /**
     * 检查用户名是否可用
     *
     * @param empName
     * @return
     */
    @RequestMapping("/checkuser")
    @ResponseBody
    public Msg checkUser(@RequestParam("empName") String empName) {
        //先判断用户名是否是合法的表达式
        String regex = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
        if (!empName.matches(regex)) {
            return Msg.fail().add("va_msg", "用户名可以是2-5位中文或6-16位英文和数字的组合");
        }
        //数据库用户名重复校验
        boolean b = employeeService.checkUser(empName);
        if (b) {
            return Msg.success().add("va_msg", "用户名可用");
        } else {
            return Msg.fail().add("va_msg", "用户名不可用");
        }
    }


    /**
     * 员工保存
     * 1.支持JSR303校验
     * 2.导入Hibernate-VAlidator包
     *
     * @return
     */
    @RequestMapping(value = "/emp", method = RequestMethod.POST)
    @ResponseBody//@ResponseBody注解：把返回值转换为json字符串
    public Msg saveEmp(@Valid Employee employee, BindingResult result) {
        if (result.hasErrors()) {
            //校验失败，应该返回失败，在模态框中显示你校验失败的错误信息
            Map<String, Object> map = new HashMap<>();
            List<FieldError> fieldErrors = result.getFieldErrors();
            for (FieldError fieldError : fieldErrors) {
                map.put(fieldError.getField(), fieldError.getDefaultMessage());
            }
            //校验失败，应该返回失败，在模态框中显示校验失败的错误信息
            return Msg.fail().add("errorFieldMap", map);
        } else {
            employeeService.saveEmp(employee);
            return Msg.success();
        }
    }


    /**
     * 使用@Response注解需要到如Jackson包，作用是把返回的对象转为json字符串
     *
     * @param pn
     * @return
     */
    @RequestMapping("/emps")
    @ResponseBody  //@ResponseBody：把返回的对象转为json字符串
    public Msg getEmpsWithJson(@RequestParam(value = "pn", defaultValue = "1") Integer pn) {
        //引入pageHelper分页插件
        //在查询之前只需要调用，传入页码，以及每页的大小
        PageHelper.startPage(pn, 5);
        //startPage紧跟的查询就是一个分页查询
        List<Employee> emps = employeeService.getAll();
        //使用pageInfo包装查询后的结果，只需要将pageInfo交给页面就行了
        //pageInfo封装了详细的分页信息，也包括查询出来的信息，传入连续显示的页数
        PageInfo<Employee> employeePageInfo = new PageInfo<>(emps, 5);
        return Msg.success().add("employeePageInfo", employeePageInfo);
    }


//    /**
//     * 查询员工数据（分页查询）
//     *
//     * @return
//     */
//    @RequestMapping("/emps")
//    public String getEmps(@RequestParam(value = "pn", defaultValue = "1") Integer pn, Model model) {
//        //引入pageHelper分页插件
//        //在查询之前只需要调用，传入页码，以及每页的大小
//        PageHelper.startPage(pn, 5);
//        //startPage紧跟的查询就是一个分页查询
//        List<Employee> emps = employeeService.getAll();
//        //使用pageInfo包装查询后的结果，只需要将pageInfo交给页面就行了
//        //pageInfo封装了详细的分页信息，也包括查询出来的信息，传入连续显示的页数
//        PageInfo<Employee> employeePageInfo = new PageInfo<>(emps, 5);
//        model.addAttribute("employeePageInfo", employeePageInfo);
//        return "list";
//    }
}
