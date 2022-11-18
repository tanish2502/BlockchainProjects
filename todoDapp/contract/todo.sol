//SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.7.0 <0.9.0;

contract Task{
    event AddTask(uint16 taskId, string recipient);
    event DeleteTask(uint16 taskId, bool isTaskDelete);

    struct task{
        uint16 taskId;
        string taskTest;
        bool isTaskDeleted;
    }

    //array of all the tasks
    task[] tasks;

}
