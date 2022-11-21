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

    function getMyTask() external view returns(task[] memory)
    {
        task[] memory temporary = new task[](tasks.length);
        uint counter = 0;

        //getting all the tasks in temporary array which are not deleted
        for(uint i = 0; i < tasks.length; i++)
        {
            if(taskOfOwner[i] == msg.sender && tasks[i].isTaskDeleted == false)
            {
                temporary[counter] = tasks[i];
                counter++;
            }
        }
        //returning all the sender's tasks in result array
        task[] memory result = new task[](counter);
        for(uint i = 0; i < counter; i++)
        {
            result[i] = temporary[i];
        }
        return result;
    }

    function deletaTask(uint _taskId, bool _isDeleted) external
    {
        if(taskOfOwner[_taskId] == msg.sender)
        {
            tasks[_taskId].isTaskDeleted = _isDeleted;
        }
        emit DeleteTask(_taskId, _isDeleted);
    }

}
