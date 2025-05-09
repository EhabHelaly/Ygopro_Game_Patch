--All For One
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_COUNTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetCountLimit(1,{id,1})
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)
end
s.listed_series={0xff8}
s.counter_plae_list={0x1ff8}
function s.remfilter(c)
	return c:GetCounter(0x1ff8)>0
end
function s.getCountersOnField(tp)
    local g=Duel.GetMatchingGroup(s.remfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    local counters=0
    local c=g:GetFirst()
    for c in aux.Next(g) do
        counters=counters+c:GetCounter(0x1ff8)
    end
    return counters
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return s.getCountersOnField(tp)>0
        and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
    end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,s.getCountersOnField(tp),0,0x1ff8)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local g=Duel.GetMatchingGroup(s.remfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
        local counters=0
        local c=g:GetFirst()
        for c in aux.Next(g) do
            counters=counters+c:GetCounter(0x1ff8)
            c:RemoveCounter(tp,0x1ff8,c:GetCounter(0x1ff8),REASON_EFFECT)
        end
        if counters>0 then tc:AddCounter(0x1ff8,counters) end
    end
end
function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xff8) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) 
		and not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(s.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
