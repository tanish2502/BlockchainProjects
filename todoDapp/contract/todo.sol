//SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.7.0 <0.9.0;

contract Task{
    event AddTask(uint taskId, address recipient);
    event DeleteTask(uint taskId, bool isTaskDelete);

    struct task{
        uint taskId;
        string taskText;
        bool isTaskDeleted;
    }

    //array of all the tasks
    task[] private tasks;
    mapping(uint => address) taskOfOwner;

    function addTask(string memory _taskText, bool _isDeleted) external
    {
        uint taskId = tasks.length;
        tasks.push(task(taskId, _taskText, _isDeleted));
        taskOfOwner[taskId] = msg.sender;
        emit AddTask(taskId, msg.sender);
    }

    function getTask(uint _taskId) external view returns(uint, string memory, bool)
    {
        return (tasks[_taskId].taskId, tasks[_taskId].taskText, tasks[_taskId].isTaskDeleted);
    }

}
